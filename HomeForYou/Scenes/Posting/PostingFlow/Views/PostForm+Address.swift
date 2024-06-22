//
//  CreateAddressView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/4/23.
//

import SwiftUI
import XUI
import CoreLocation

struct PostForm_Address<T: Postable>: View {
    
    enum FocusedField: Hashable {
        case postalCode, addressText
    }
    
    @FocusState private var focused: FocusedField?
    @StateObject private var viewModel = PostingFlowAddressViewModel()
    
    @State private var post: T
    
    @Environment(\.makeRequestPostUpdate) private var onTakePostingAction
    
    init(_ post: T) {
        self.post = post
    }
    var body: some View {
        Form {
            if viewModel.location.isEmpty {
                Section {
                    Text("Enter the postal code of your property")
                        .font(.headline)
                        .showLoading(viewModel.loading)
                        .listRowBackground(Color.clear.hidden())
                }
                Section {
                    HStack {
                        TextField("Postal code", text: $viewModel.searchText)
                            .keyboardType(.numberPad)
                            .textContentType(.postalCode)
                            .focused($focused, equals: .postalCode)
                            .onChange(of: viewModel.searchText, debounceTime: .seconds(0.5)) { _, newValue in
                                if newValue.count == 6 && Int(newValue) != nil {
                                    Task {
                                        await viewModel.handlePostalCode(postalCode: newValue)
                                    }
                                }
                            }
                        AsyncButton {
                            await self.viewModel.handlePostalCode(postalCode: viewModel.location.address.postal)
                            focused = nil
                        } label: {
                            SystemImage(.magnifyingglassCircleFill)
                        }
                        .disabled(viewModel.searchText.isWhitespace)
                    }
                } footer: {
                    Text("Alternatively you can select the location by dragging on the map")
                }
                Section {
                    AsyncButton {
                        await viewModel.startCurrentLocation()
                    } label: {
                        Label("Use current location as address", systemSymbol: .mappinAndEllipse)
                    }
                    Label("Search the Address", systemSymbol: .magnifyingglass)
                        ._presentSheet {
                            AddressPickerView(addressText: $viewModel.location.address.text)
                        }
                    Label("Select address from Map", systemSymbol: .map)
                        ._presentSheet {
                            LocationPickerMap { info in
                                await MainActor.run {
                                    self.viewModel.location = info
                                }
                            }
                        }
                }
                
            } else {
                Section {
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
                            .listRowBackground(Color.clear.hidden())
                            ._onAppear(after: 0.5) {
                                focused = nil
                            }
                    }
                } header: {
                    Text(viewModel.location.address.text)
                } footer: {
                    _ConfirmButton("Reset the address") {
                        viewModel.reset()
                        focused = .postalCode
                    } label: {
                        Text("Reset")
                    }
                    .disabled(viewModel.location.isEmpty)
                }
            }
            
            Spacer(minLength: 100)
                .listRowBackground(Color.clear.hidden())
        }
        .alertPresenter($viewModel.alert)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("@address")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                AsyncButton {
                    await onTakePostingAction?(.cancel)
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                SystemImage(.mappinAndEllipse)
                    ._presentSheet {
                        LocationPickerMap { info in
                            await MainActor.run {
                                self.viewModel.location = info
                            }
                        }
                        .presentationDetents([.medium])
                    }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Text("next")
                    ._borderedProminentLightButtonStyle()
                    ._tapToPush {
                        PostForm_Attachmments($post)
                    }
                    .disabled(!viewModel.location.isValid)
            }
        }
        .onAppear {
            if viewModel.location.isEmpty {
                if post._location.isEmpty {
                    focused = .postalCode
                } else {
                    viewModel.location = post._location
                }
            }
        }
        .lazySync($post._location, $viewModel.location)
    }
}

private final class PostingFlowAddressViewModel: ViewModel, ObservableObject {
    
    @Published var searchText = ""
    @Published var alert: XUI._Alert?
    @Published var loading: Bool = false
    @Published var location: LocationInfo = .empty
    
    private let locationPublisher = CurrentLocationPublisher()
    private let cancelBag = CancelBag()
    
    init() {
        $location
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .asyncSink { [weak self] value in
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
            .asyncSink { [weak self] value in
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
