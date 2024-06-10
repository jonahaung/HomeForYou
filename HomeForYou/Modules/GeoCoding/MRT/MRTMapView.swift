//
//  MRTMapView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import SwiftUI
import MapKit
import XUI

struct MRTService: Hashable, Identifiable {
    
    let id: String
    let line: MRTLine
    let mrts: [MRT]
    let polygonRegion: PolygonRegion
    
    init(_ line: MRTLine) {
        self.id = line.id
        self.line = line
        self.mrts = line.mrts
        self.polygonRegion = .init(verticies: line.mrts.map{ $0.coordinate })
    }
    var coordinates: [CLLocationCoordinate2D] { polygonRegion.verticies }
}

struct MRTMapView: View {
    
    @State var selection: MRT?
    @State var selectedService: MRTService?
    var onSelect: @Sendable (MRT) async -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .automatic
    @State private var searchText = ""
    @State private var animation: MapKeyFrameAnimation = .init()
    @FocusState private var isSearching: Bool
    @State private var searchedMRTs = [MRT]()
    private let allMRTs = MRT.allValues
    private let mrtServices: [MRTService] = MRTLine.allCases.map(MRTService.init)
    
    var body: some View {
        MapReader { proxy in
            Map(position: $position, selection: $selection) {
                if let selectedService {
                    MapPolyline(coordinates: selectedService.coordinates, contourStyle: .geodesic)
                        .stroke(selectedService.line.color.gradient, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    
                    let filteredMRTs = isSearching ? searchedMRTs : selectedService.mrts
                    
                    ForEach(filteredMRTs) { mrt in
                        if let mainSymbol = mrt.mainSymbol(for: selectedService.line) {
                            Marker(mrt.name, monogram: Text("\(mainSymbol.code)"), coordinate: mrt.coordinate)
                                .tint(mainSymbol.swiftColor.gradient)
                                .tag(mrt)
                            
                            ForEach(mrt.symbol) { symbol in
                                if symbol.code != mainSymbol.code {
                                    Annotation.init(symbol.code, coordinate: mrt.coordinate) {
                                        SystemImage(.circlebadgeFill)
                                            .foregroundStyle(symbol.swiftColor.gradient)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ForEach(mrtServices) { mrtService in
                        MapPolyline(coordinates: mrtService.coordinates, contourStyle: .geodesic)
                            .stroke(mrtService.line.color.gradient, style: StrokeStyle(lineWidth: isSearching ? 1 : 5, lineCap: .round, lineJoin: .round))
                        
                        if isSearching {
                            ForEach(searchedMRTs) { mrt in
                                if let mainSymbol = mrt.mainSymbol(for: mrtService.line) {
                                    Marker(mrt.name, monogram: Text("\(mainSymbol.code)"), coordinate: mrt.coordinate)
                                        .tint(mainSymbol.swiftColor.gradient)
                                        .tag(mrt)
                                    
                                    ForEach(mrt.symbol) { symbol in
                                        if symbol.code != mainSymbol.code {
                                            Annotation.init(symbol.code, coordinate: mrt.coordinate) {
                                                SystemImage(.circlebadgeFill)
                                                    .foregroundStyle(symbol.swiftColor.gradient)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .equatable(by: animation)
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    if !isSearching && selectedService == nil {
                        _Haptics.play(.rigid)
                        let nearest = MRT.closestMRT(from: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        let service = mrtServices.first(where: { $0.mrts.contains { element in
                            element.name == nearest.mrt
                        } })
                        selectedService = service
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .flat, emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: false))
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .mapControlVisibility(.visible)
        .mapCameraKeyframeAnimator(trigger: animation, keyframes: { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(animation.coordinate ?? camera.centerCoordinate, duration: 0.5)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(animation.distance ?? camera.distance, duration: animation.distance == nil ? 0 : 1)
            }
            KeyframeTrack(\MapCamera.pitch) {
                LinearKeyframe(animation.pitch ?? camera.pitch, duration: animation.pitch == nil ? 0 : 2)
            }
        })
        .ignoresSafeArea(edges: .bottom)
        .safeAreaInset(edge: .top) { overlayTopView }
        .safeAreaInset(edge: .bottom) { overlayBottomView }
        .onChange(of: selection) { _, newValue in
            if !isSearching {
                if let newValue {
                    animation = .init(newValue.coordinate, distance: 3000, pitch: 75)
                } else {
                    if let selectedService {
                        animation = .init(selectedService.polygonRegion.center, distance: 80000)
                    } else {
                        animation = .init(.singapore, distance: 80000)
                    }
                }
            }
        }
        .onChange(of: selectedService) { _, newValue in
            if let newValue {
                animation = .init(newValue.polygonRegion.center, distance: 80000)
            } else {
                animation.distance = 181000
            }
        }
        .onChange(of: isSearching) { _, newValue in
            searchedMRTs.removeAll()
            DispatchQueue.delay {
                let coordinate: CLLocationCoordinate2D = {
                    if newValue {
                        let polygonRegion = PolygonRegion(verticies: allMRTs.map{ $0.coordinate })
                        let center =  polygonRegion.center
                        return CLLocationCoordinate2D(latitude: center.latitude - (polygonRegion.latSpan * 1.1), longitude: center.longitude)
                    }
                    return .singapore
                }()
                animation = .init(coordinate, distance: newValue ? 140000 : 90000)
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            let mrts: [MRT] = {
                if let selectedService {
                    return selectedService.mrts
                }
                return allMRTs
            }()
            searchedMRTs = {
                if newValue.isWhitespace {
                    return mrts
                }
                return mrts.filter{ $0.name.contains(newValue, caseSensitive: false)}
            }()
            guard !searchedMRTs.isEmpty else {
                animation.pitch = 25
                return
            }
            let polygonRegion = PolygonRegion(verticies: searchedMRTs.map{ $0.coordinate })
            let center =  polygonRegion.center
            let coordinate = CLLocationCoordinate2D(latitude: center.latitude - (polygonRegion.latSpan * 1.2), longitude: center.longitude)
            animation.coordinate = coordinate
        }
        ._onAppear(after: 1) {
            animation.distance = 160000
        }
    }
    
    private var overlayTopView: some View {
        VStack {
            HStack {
                _DismissButton(isProtected: selection != nil, title: "Cancel")
                    ._overlayLightButtonStyle()
                Spacer()
            }
        }
        .padding()
    }
    private var overlayBottomView: some View {
        VStack {
            HStack(alignment: .bottom) {
                if selection != nil {
                    Button.init {
                        selection = nil
                    } label: {
                        SystemImage(.trashFill)
                            .symbolRenderingMode(.multicolor)
                            ._overlayLightButtonStyle()
                    }
                }
                if let selectedService {
                    Text(selectedService.line.name)
                        .bold()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    ForEach(mrtServices) { mrtService in
                        AsyncButton {
                            onSelectService(mrtService)
                        } label: {
                            Circle().fill(mrtService.line.color.gradient)
                                .frame(square: mrtService == selectedService ? 50 : 30)
                        }
                    }
                }
                .animation(.interactiveSpring, value: selectedService)
            }
            if !isSearching, let selection {
                AsyncButton {
                    await onSelect(selection)
                    try await Task.sleep(seconds: 1)
                    dismiss()
                } label: {
                    Text("Apply")
                        ._borderedProminentLightButtonStyle()
                }
            }
            if isSearching || selection == nil {
                HStack {
                    TextField("Search stations by name", text: $searchText)
                        .focused($isSearching)
                        .padding(.leading)
                        .padding(.vertical, 8)
                        .background(.bar, in: Capsule())
                    if isSearching {
                        Button {
                            if searchText.isWhitespace {
                                isSearching = false
                            } else {
                                searchText = String()
                            }
                        } label: {
                            Text(searchText.isWhitespace ? "Cancel" : "Clear")
                                ._overlayLightButtonStyle()
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private func onSelectService(_ mrtService: MRTService?) {
        _Haptics.play(.light)
        selectedService = mrtService == selectedService ? nil : mrtService
    }
}
