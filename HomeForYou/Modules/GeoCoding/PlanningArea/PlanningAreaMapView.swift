//
//  AreaMapView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import SwiftUI
import MapKit
import XUI

struct PlanningAreaMapView: View {
    
    @State private var position: MapCameraPosition = .automatic
    private let planningAreas = PlanningArea.items
    @State var selection: PlanningArea? = .init(name: "", geometry: .polygon([]))
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        MapReader { proxy in
            Map(position: $position) {
                ForEach(planningAreas) { area in
                    Annotation(coordinate: area.geometry.centerCoordinates.first ?? .init()) {
                    } label: {
                        Text(area.name)
                    }
                    let isSelected = selection == area
                    switch area.geometry {
                    case .polygon(let coordinates):
                        if isSelected {
                            MapPolygon(coordinates: coordinates)
                                .foregroundStyle(Color.random(seed: area.name))
                        } else {
                            MapPolyline(coordinates: coordinates)
                                .stroke(Color.primary, lineWidth: 1)
                        }
                    case .multiPolygon(let poligons):
                        ForEach(poligons, id: \.self) { coordinates in
                            if isSelected {
                                MapPolygon(coordinates: coordinates)
                                    .foregroundStyle(Color.random(seed: area.name))
                            } else {
                                MapPolyline(coordinates: coordinates)
                                    .stroke(Color.primary, lineWidth: 1)
                            }
                        }
                    }
                }
            }
            .mapControls {
                MapCompass()
                MapScaleView()
                MapUserLocationButton()
            }
            .mapStyle(.standard(elevation: .automatic, emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: false))
            .mapCameraKeyframeAnimator(trigger: selection, keyframes: { camera in
                KeyframeTrack(\MapCamera.centerCoordinate) {
                    LinearKeyframe(selection?.geometry.centerCoordinates.last ?? camera.centerCoordinate, duration: 1)
                }
                KeyframeTrack(\MapCamera.distance) {
                    LinearKeyframe(100000, duration: 0.5)
                    LinearKeyframe(selection == nil ? 200000 : 60000, duration: 1)
                }
            })
            .onTapGesture { position in
                if let coordinate =  proxy.convert(position, from: .local) {
                    _Haptics.play(.rigid)
                    guard let area = planningAreas.first(where: { $0.geometry.isContain(coordinate)}) else {
                        selection = nil
                        return
                    }
                    selection = area == selection ? nil : area
                } else {
                    selection = nil
                }
            }
            .statusBar(hidden: true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selection = nil
                    } label: {
                        Text("Clear")
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        dismiss()
                    } label: {
                        Text(selection == nil ? "Cancel" : "Done")
                    }
                }
            }
            ._onAppear(after: 1) {
                selection = nil
            }
        }
    }
}
