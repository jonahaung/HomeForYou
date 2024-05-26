//
//  LocationMap.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/2/24.
//

import SwiftUI
import MapKit
import XUI
import SFSafeSymbols

struct LocationMap: View {
    
    private var items: [LocationMapItem]
    @State var selected: LocationMapItem?
    @State private var position: MapCameraPosition
    @State private var trigger = false
    @State private var lookAroundScene: MKLookAroundScene?
    
    init(_ items: [LocationMapItem]) {
        position = .camera(.init(centerCoordinate: LocationMapItem.centerCoordinate(for: items), distance: 10_000))
        self.items = items
    }
    var body: some View {
        Map(position: $position, selection: $selected) {
            ForEach(items) { item in
                Marker(item.title, monogram: Text(item.subtitle), coordinate: item.coordinate)
                    .tag(item)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .mapCameraKeyframeAnimator(trigger: trigger) { camera in
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(2000, duration: 2)
            }
        }
        ._onAppear(after: 3) {
            trigger = true
        }
        .onChange(of: selected, { oldValue, newValue in
            if let newValue {
                Task {
                    let request = MKLookAroundSceneRequest(coordinate: newValue.coordinate)
                    do {
                        let lookAroundScene = try await request.scene
                        await MainActor.run {
                            self.lookAroundScene = lookAroundScene
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        })
        .sheet(item: $lookAroundScene) {
            LocationPreviewLookAroundView(lookAroundScene: $0)
                .presentationDetents([.medium])
        }
    }
}

extension MKLookAroundScene: Identifiable {
    public var id: String { self.description }
}
