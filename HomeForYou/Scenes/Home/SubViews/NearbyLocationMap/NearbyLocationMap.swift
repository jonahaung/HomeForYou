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

struct NearbyLocationMap: View {
    
    var items: [Post]
    @Binding var currentLocation: CLLocationCoordinate2D?
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selection: LocationMapItem?
    
    var body: some View {
        Map(position: $position, interactionModes: [.zoom, .pan], selection: $selection) {
            ForEach(items) { post in
                let item = post.locationMapItem
                Marker(item.title, monogram: Text(item.subtitle), coordinate: item.coordinate)
                    .tag(item)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            guard currentLocation != context.region.center else { return }
            currentLocation = context.region.center
        }
    }
}
