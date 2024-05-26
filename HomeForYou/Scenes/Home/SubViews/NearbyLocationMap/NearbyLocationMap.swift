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
    
    var items: [Post]
    @Binding var currentLocation: CLLocationCoordinate2D?
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selection: Post?
    
    var body: some View {
        Map(position: $position, interactionModes: [.zoom, .pitch, .pan], selection: $selection) {
            ForEach(items) { post in
                Marker("$\(post.price)", coordinate: .init(latitude: post.latitude, longitude: post.longitude))
                    .tag(post)
                
            }
            if let currentLocation {
                Marker("\(items.count)", coordinate: currentLocation)
                    .tint(.red)
            }
        }
        .mapControls {
            MapScaleView()
            MapUserLocationButton()
        }
        .onMapCameraChange(frequency: .continuous) { context in
            guard currentLocation != context.region.center else { return }
            if currentLocation == nil {
                SecureStorage.shared.set(context.region.center.geohash(length: 6), forKey: Constansts.Defaults.currentUserRegion.rawValue)
            }
            currentLocation = context.region.center
        }
        .mapCameraKeyframeAnimator(trigger: items, keyframes: { camera in
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(items.isEmpty ? 2000 : 1000, duration: 1)
            }
            KeyframeTrack(\MapCamera.pitch) {
                LinearKeyframe(0, duration: 0.5)
                LinearKeyframe(50, duration: 1)
            }
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(items.first?.locationMapItem.coordinate ?? camera.centerCoordinate, duration: 0.5)
                LinearKeyframe(items.last?.locationMapItem.coordinate ?? camera.centerCoordinate, duration: 1)
            }
        })
    }
}
