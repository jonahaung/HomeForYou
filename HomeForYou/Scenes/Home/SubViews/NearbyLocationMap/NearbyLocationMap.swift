//
//  NearbyLocationMap.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 22/5/24.
//

import SwiftUI
import MapKit
import XUI
import SFSafeSymbols
import SecureStorage

struct NearbyLocationMap: View {
    
    var coordinate: CLLocationCoordinate2D
    @State private var position: MapCameraPosition = .automatic
    @State private var animate = false
    
    var body: some View {
        Map(position: $position, interactionModes: [.zoom, .pitch, .pan]) {
            Marker(coordinate.geohash(length: 15), coordinate: coordinate)
                .tint(.red)
        }
        .mapControls {
            MapCompass()
            MapScaleView()
            MapUserLocationButton()
        }
        .onMapCameraChange(frequency: .onEnd, { context in
            animate = false
        })
        .mapCameraKeyframeAnimator(trigger: animate, keyframes: { camera in
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(2000, duration: 2)
                LinearKeyframe(1000, duration: 2)
            }
            KeyframeTrack(\MapCamera.pitch) {
                LinearKeyframe(0, duration: 2)
                LinearKeyframe(50, duration: 2)
            }
        })
        .onAppear {
            animate = true
        }
    }
}
