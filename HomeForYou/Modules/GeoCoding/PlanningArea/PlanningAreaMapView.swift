//
//  AreaMapView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import SwiftUI
import MapKit
import XUI
import SFSafeSymbols

struct PlanningAreaMapView: View {
    
    var onSelect: @Sendable (PlanningArea) async -> Void
    @State var selection: PlanningArea? = .init(name: "", geometry: .polygon(.init(verticies: [])))
    @State private var position: MapCameraPosition = .automatic
    @State private var planningAreas = [PlanningArea]()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        MapReader { proxy in
            Map(position: $position, interactionModes: [.zoom, .pan]) {
                ForEach(planningAreas) { area in
                    let isSelected = selection == area
                    switch area.geometry {
                    case .polygon(let region):
                        MapPolyline(coordinates: region.verticies)
                            .stroke(isSelected ? Color.accentColor : Color.secondary, lineWidth: isSelected ? 2 : 1)
                    case .multiPolygon(let regions):
                        ForEach(regions, id: \.id) { region in
                            MapPolyline(coordinates: region.verticies)
                                .stroke(isSelected ? Color.accentColor : Color.secondary, lineWidth: isSelected ? 2 : 1)
                        }
                    }
                    Annotation(coordinate: area.geometry.centerCoordinates.first ?? .init()) {
                        if isSelected {
                            Text(area.name)
                                .fontWeight(.bold)
                        }
                    } label: {
                        if !isSelected {
                            Text(area.name)
                        }
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate =  proxy.convert(position, from: .local) {
                    _Haptics.play(.rigid)
                    guard let area = PlanningArea(coordinate) else {
                        selection = nil
                        return
                    }
                    selection = area == selection ? nil : area
                } else {
                    selection = nil
                }
            }
        }
        .mapStyle(.standard(elevation: .flat, emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: false))
        .mapControls {
            MapCompass()
            MapScaleView()
            MapUserLocationButton()
        }
        .mapCameraKeyframeAnimator(trigger: selection, keyframes: { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(selection?.geometry.centerCoordinates.middle ?? PlanningArea(.Bishan)?.geometry.centerCoordinates.middle ?? .init(), duration: 1.2)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(100000, duration: 0.5)
                LinearKeyframe(selection == nil ? 181000 : 60000, duration: 0.7)
            }
        })
        .mapControlVisibility(selection == nil ? .visible : .hidden)
        .safeAreaInset(edge: .bottom) {
            HStack {
                _DismissButton(isProtected: selection != nil, title: "Close")
                Spacer()
                if let selection {
                    AsyncButton {
                        await onSelect(selection)
                        try await Task.sleep(seconds: 1)
                        dismiss()
                    } label: {
                        Text("Apply")
                    }
                }
            }
            .padding()
        }
        .statusBar(hidden: true)
        .interactiveDismissDisabled(selection != nil)
        ._onAppear(after: 1) {
            selection = nil
        }
        .task {
            planningAreas = PlanningArea.items
        }
        .equatable(by: selection)
    }
}
