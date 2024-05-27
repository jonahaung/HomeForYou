//
//  CreateAddressView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/4/23.
//

import SwiftUI
import XUI

struct PostForm_Address: View {
    
    @EnvironmentObject private var post: Post
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CreateAddressViewModel()
    @Injected(\.ui) private  var ui
    @Environment(PostingFlowRouter.self) private var router
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Postal code", text: $viewModel.location.address.postal)
                        .keyboardType(.numberPad)
                        .textContentType(.postalCode)
                    
                    AsyncButton {
                        await self.viewModel.handlePostalCode(postalCode: viewModel.location.address.postal)
                    } label: {
                        SystemImage(.magnifyingglass)
                            .imageScale(.large)
                    }
                    .disabled(viewModel.location.address.postal.count != 6)
                }
            } header: {
                Text("Please enter of find your address")
                    .textCase(nil)
            } footer: {
                Text("Enter the postal code and press the search icon")
            }
            // Search from Map
            Section {
                HStack {
                    TextField("Full address", text: $viewModel.location.address.text, axis: .vertical)
                        .textContentType(.fullStreetAddress)
                    AsyncButton {
                        await self.viewModel.handleAderessText(text: viewModel.location.address.text)
                    } label: {
                        SystemImage(.magnifyingglass)
                            .imageScale(.large)
                    }
                    .disabled(viewModel.location.address.text.isWhitespace)
                }
                
                if viewModel.location.geoInfo.isValid {
                    XNavPickerBar("Area", Area.allCases.filter { $0 != .Any }, $viewModel.location.area)
                    MRTPickerBar(mrt: $viewModel.location.nearestMRT.mrt)
                    _FormCell {
                        Text("Geo Hash")
                    } right: {
                        Text(viewModel.location.geoInfo.geoHash)
                    }
                    Text("\(viewModel.location.nearestMRT.distance)min walk from \(viewModel.location.nearestMRT.mrt) MRT")
                        .italic()
                    
                    let location = viewModel.location.geoInfo.location
                    Grid(alignment: .center) {
                        GridRow {
                            Text(location.coordinate.longitude.description)
                            Text(location.coordinate.latitude.description)
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                    MapSnapshotView(
                        location: GeoLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    )
                    .frame(height: 250)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            } footer: {
                Text("Enter the full address and press the search icon")
            }
            Section {
                Group {
                    AsyncButton {
                        await viewModel.startCurrentLocation()
                    } label: {
                        Text("\(Image(systemSymbol: .mappinAndEllipse)) Use current location as address")
                            ._borderedProminentLightButtonStyle()
                    }
                    .appPermissionOverlay(.currentLocation)
                    Text("\(Image(systemSymbol: .magnifyingglass)) Search the Address")
                        ._borderedProminentLightButtonStyle()
                        ._presentSheet {
                            AddressPickerView(addressText: $viewModel.location.address.text)
                        }
                }
                .listRowBackground(EmptyView())
                .listRowSeparator(.hidden)
            }
        }
        .animation(.default, value: viewModel.location)
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("@address")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                _DismissButton(isProtected: viewModel.location.isValid, title: "Close")
            }
            ToolbarItemGroup(placement: .bottomBar) {
                _ConfirmButton("Reset the address") {
                    viewModel.reset()
                } label: {
                    Text("Reset")
                }
                .disabled(viewModel.location.isEmpty)
                
                Button {
                    router.path.append(.attachments)
                } label: {
                    Text("next \(Image(systemSymbol: .arrowshapeForwardFill))")
                }
                .disabled(!viewModel.location.isValid)
            }
        }
        .showLoading(viewModel.loading)
        .alertPresenter($viewModel.alert)
        .synchronizeLazily($post._location, $viewModel.location)
    }
}

@Observable
private final class CreateAddressViewModel: ViewModel {
    
    var alert: XUI._Alert?
    var loading: Bool = false
    var location = LocationInfo.empty
    
    private let locationPublisher = LocationPublisher()
    private let cancelBag = CancelBag()
    
    func startCurrentLocation() async {
        locationPublisher.stopUpdatingLocation()
        locationPublisher
            .locationPublisher()
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                do {
                    await setLoading(true)
                    let location = try await GeoCoder.createLocationInfo(from: value)
                    await self.setLoading(false)
                    await updateLocation(location)
                } catch {
                    await updateLocation(.empty)
                    await self.showAlert(.init(error: error))
                }
            }
            .store(in: cancelBag)
        locationPublisher.startUpdatingLocation()
    }
    func reset() {
        location = LocationInfo.empty
    }
    func handlePostalCode(postalCode: String) async {
        do {
            let location = try await GeoCoder.createLocationInfo(postalCode)
            await updateLocation(location)
        } catch {
            await showAlert(.init(error: error))
        }
    }
    func handleAderessText(text: String) async {
        do {
            let location = try await GeoCoder.createLocationInfo(from: text)
            await updateLocation(location)
        } catch {
            await showAlert(.init(error: error))
        }
    }
    @MainActor func updateLocation(_ location: LocationInfo) {
        self.location = location
    }
}
