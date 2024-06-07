//
//  MRTMapView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import SwiftUI
import MapKit
import XUI
import URLImage

struct MRTMapView: View {
    
    @State private var coordinate: CLLocationCoordinate2D = LocationInfo.empty.geoInfo.coordinate
    @State private var position: MapCameraPosition = .automatic
    @State private var mrts = MRT.allValues
    @State private var selection: MRT?
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLine: MRTLine?
    
    private var results: [MRT] {
        guard let mrts = selectedLine?.mrts else { return [] }
        guard !searchText.isWhitespace else {
            return mrts
        }
        return mrts.filter{ $0.name.contains(searchText, caseSensitive: false) }
    }
    @Namespace var mapScope
    var body: some View {
        
        Map(position: $position, interactionModes: .all, selection: $selection, scope: mapScope) {
            if let selectedLine {
                if let selection {
                    Annotation.init(coordinate: selection.coordinate) {
                        Image(systemName: "circle.fill")
                            .foregroundStyle (Color.red)
                    } label: {
                        Text("")
                    }
                }
                ForEach(results) { each in
                    Marker.init(each.name, monogram: Text(each.mainSymbol(for: selectedLine.rawValue).code), coordinate: each.coordinate)
                        .tint(each == selection ? Color.accentColor : selectedLine.color)
                        .tag(each)
                    
                }
                if searchText.isEmpty {
                    MapPolyline.init(coordinates: results.map{ $0.coordinate }, contourStyle: MapPolyline.ContourStyle.straight)
                        .stroke(selectedLine.color, lineWidth: 3)
                }
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .onMapCameraChange(frequency: .continuous) { context in
            coordinate = context.camera.centerCoordinate
        }
        .mapCameraKeyframeAnimator(trigger: selectedLine, keyframes: { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(selectedLine?.mrts.middle?.coordinate ?? .init(), duration: 2)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(80000, duration: 1)
                LinearKeyframe(3000, duration: 2)
            }
            KeyframeTrack(\MapCamera.pitch) {
                LinearKeyframe(0, duration: 2)
                LinearKeyframe(75, duration: 4)
            }
        })
        .mapStyle(.standard)
        .ignoresSafeArea(.keyboard)
        .statusBar(hidden: true)
        .overlay { overlayView }
        .animation(.interactiveSpring, value: selectedLine)
        ._onAppear(after: 1) {
            selectedLine = .blue
        }
    }
    private var overlayView: some View {
        VStack {
            HStack {
                TextField("Search stations by name", text: $searchText)
                    .padding(.leading)
                    .padding(.vertical, 8)
                    .background(.bar)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    ForEach(MRTLine.allCases) { each in
                        Button {
                            _Haptics.play(.light)
                            selectedLine = each
                        } label: {
                            Circle().fill(each.color.gradient)
                                .frame(square: each == selectedLine ? 65 : 30)
                        }
                    }
                }
            }
            
        }
        .padding()
        .zIndex(5)
    }
    
    
}

extension Array {
    var middle: Element? {
        guard count != 0 else { return nil }
        
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
    
}
