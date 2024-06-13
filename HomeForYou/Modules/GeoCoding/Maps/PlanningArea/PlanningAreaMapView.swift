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
    @State private var animation: MapKeyFrameAnimation = .init()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        MapReader { proxy in
            Map(position: $position) {
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
                    Annotation(coordinate: area.geometry.centerCoordinate) {
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
            .equatable(by: selection)
            .onTapGesture { position in
                if let coordinate =  proxy.convert(position, from: .local) {
                    if let area = PlanningArea(coordinate) {
                        _Haptics.play(.rigid)
                        selection = area == selection ? nil : area
                    } else {
                        selection = nil
                    }
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
        .mapCameraKeyframeAnimator(trigger: animation, keyframes: { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(animation.coordinate ?? camera.centerCoordinate, duration: animation.coordinate == nil ? 0 : 1)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(100000, duration: animation.distance == nil ? 0 : 0.5)
                LinearKeyframe(animation.distance ?? camera.distance, duration: animation.distance == nil ? 0 : 1)
            }
        })
        .mapControlVisibility(selection == nil ? .visible : .hidden)
        .safeAreaInset(edge: .bottom) {
            HStack {
                _DismissButton(isProtected: selection != nil, title: "Close")
                    ._overlayLightButtonStyle()
                Spacer()
                if let selection {
                    AsyncButton {
                        await onSelect(selection)
                        try await Task.sleep(seconds: 1)
                        dismiss()
                    } label: {
                        Text("Apply")
                            ._borderedProminentLightButtonStyle()
                    }
                }
            }
            .padding()
        }
        .statusBar(hidden: true)
        .task {
            planningAreas = PlanningArea.allCases
        }
        ._onAppear(after: 1) {
            selection = nil
        }
        .onChange(of: selection) { oldValue, newValue in
            DispatchQueue.delay {
                animation = .init(newValue?.geometry.centerCoordinate, distance: selection == nil ? 181000 : 60000)
            }
        }
    }
}
