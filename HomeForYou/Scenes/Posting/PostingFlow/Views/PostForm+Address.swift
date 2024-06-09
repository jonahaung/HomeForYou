//
//  CreateAddressView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/4/23.
//

import SwiftUI
import XUI
import CoreLocation

struct PostForm_Address: View {
    
    enum FocusedField: Hashable {
        case postalCode, addressText
    }
    @FocusState private var focused: FocusedField?
    @Injected(\.ui) private  var ui
    @Environment(PostingFlowRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @Environment(\.keyboardShowing) private var keyboardShowing
    
    @StateObject private var viewModel = PostingFlowAddressViewModel()
    @Binding private var location: LocationInfo
    
    init(_ locaton: Binding<LocationInfo>) {
        self._location = locaton
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Postal code", text: $viewModel.location.address.postal)
                        .keyboardType(.numberPad)
                        .textContentType(.postalCode)
                        .focused($focused, equals: .postalCode)
                    AsyncButton {
                        await self.viewModel.handlePostalCode(postalCode: viewModel.location.address.postal)
                        focused = nil
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
                        .focused($focused, equals: .addressText)
                    AsyncButton {
                        await self.viewModel.handleAderessText(text: viewModel.location.address.text)
                        focused = nil
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
                    MapSnapshotView(location: viewModel.location.geoInfo.coordinate)
                        .frame(height: 250)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        ._onAppear(after: 0.5) {
                            focused = nil
                        }
                }
            } footer: {
                if viewModel.location.isValid {
                    Text("\(viewModel.location.geoInfo.coordinate.latitude), \(viewModel.location.geoInfo.coordinate.longitude)")
                } else {
                    Text("Enter the full address and press the search icon")
                }
            }
            Section {
                if viewModel.location.isEmpty {
                    Group {
                        AsyncButton {
                            await viewModel.startCurrentLocation()
                        } label: {
                            Text("\(Image(systemSymbol: .mappinAndEllipse)) Use current location as address")
                                ._borderedProminentLightButtonStyle()
                        }
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
        }
        .animation(.interactiveSpring, value: viewModel.location)
        .showLoading(viewModel.loading)
        .alertPresenter($viewModel.alert)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("@address")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                _DismissButton(isProtected: viewModel.location.isValid, title: "Close")
            }
            ToolbarItemGroup(placement: .bottomBar) {
                _ConfirmButton("Reset the address") {
                    viewModel.reset()
                    focused = .postalCode
                } label: {
                    Text("Reset")
                }
                .disabled(viewModel.location.isEmpty)
                
                Button {
                    location = viewModel.location
                    router.path.append(.attachments)
                } label: {
                    Text("next \(Image(systemSymbol: .arrowshapeForwardFill))")
                }
                .disabled(!viewModel.location.isValid)
            }
        }
        .onAppear {
            if viewModel.location.isEmpty {
                if location.isEmpty {
                    focused = .postalCode
                } else {
                    viewModel.location = location
                }
            }
        }
    }
}

private final class PostingFlowAddressViewModel: ViewModel, ObservableObject {
    
    @Published var alert: XUI._Alert?
    @Published var loading: Bool = false
    @Published var location: LocationInfo = .empty
    
    private let locationPublisher = CurrentLocationPublisher()
    private let cancelBag = CancelBag()
    
    init() {
        $location
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                switch true {
                case value.address.postal.count == 6 && value.address.text.isWhitespace:
                    await handlePostalCode(postalCode: value.address.postal)
                default:
                    break
                }
            }
            .store(in: cancelBag)
    }
    func startCurrentLocation() async {
        locationPublisher.stopUpdatingLocation()
        locationPublisher
            .publisher()
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                do {
                    await setLoading(true)
                    let location = try await GeoCoder.createLocationInfo(from: value)
                    await updateLocation(location)
                } catch {
                    await updateLocation(.empty)
                    await self.showAlert(.init(error: error))
                }
            }
            .store(in: cancelBag)
        locationPublisher.startUpdatingLocation()
    }
    @MainActor func reset() {
        location = LocationInfo.empty
    }
    
    func handlePostalCode(postalCode: String) async {
        await setLoading(true)
        do {
            try await Task.sleep(seconds: 1)
            let location = try await GeoCoder.createLocationInfo(postalCode)
            await updateLocation(location)
        } catch {
            await showAlert(.init(error: error))
        }
    }
    func handleAderessText(text: String) async {
        await setLoading(true)
        do {
            try await Task.sleep(seconds: 1)
            let location = try await GeoCoder.createLocationInfo(from: text)
            await updateLocation(location)
        } catch {
            await showAlert(.init(error: error))
        }
    }
    @MainActor func updateLocation(_ location: LocationInfo) {
        setLoading(false)
        self.location = location
    }
}
