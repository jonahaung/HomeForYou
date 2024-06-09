//
//  LocationPickerMap.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 9/6/24.
//

import SwiftUI
import MapKit
import XUI

struct LocationPickerMap: View {
    
    var onSelect: @Sendable (LocationInfo) async -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var selection: CLLocationCoordinate2D?
    @State private var animation: MapKeyFrameAnimation = .init()
    @State private var location: LocationInfo?
    
    var body: some View {
        Map(position: $position, interactionModes: .all, selection: $selection) {
            if let selection {
                Marker("Selected", systemImage: "star.fill", coordinate: selection)
                    .tag(selection)
            } else {
                if let coordinate {
                    Marker("Select this Location", systemImage: "plus", coordinate: coordinate)
                        .tag(coordinate)
                }
            }
        }
        .onMapCameraChange(frequency: .continuous) { context in
            if location == nil {
                coordinate = context.camera.centerCoordinate
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
            MapUserLocationButton()
        }
        .mapCameraKeyframeAnimator(trigger: animation, keyframes: { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(animation.coordinate ?? camera.centerCoordinate, duration: 1)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(animation.distance, duration: 1)
            }
            KeyframeTrack(\MapCamera.pitch) {
                LinearKeyframe(animation.pitch, duration: 3)
            }
        })
        .safeAreaInset(edge: .bottom) {
            VStack {
                if let location {
                    Text(location.address.text)
                }
                HStack {
                    if location != nil {
                        AsyncButton {
                            location = nil
                            animation.distance = 8000
                            animation.pitch = 0
                        } label: {
                            SystemImage(.trashFill, 34)
                                .symbolRenderingMode(.multicolor)
                        }
                    } else {
                        _DismissButton(isProtected: coordinate != nil, title: "Close")
                    }
                    Spacer()
                    if let location {
                        AsyncButton {
                            await onSelect(location)
                            try await Task.sleep(seconds: 1)
                            dismiss()
                        } label: {
                            Text("Apply")
                        }
                    }
                }
            }
            .padding()
        }
        .statusBar(hidden: true)
        .interactiveDismissDisabled(coordinate != nil)
        ._onAppear(after: 1) {
            animation.distance = 5000
        }
        .onChange(of: selection) {
            if let selection {
                Task {
                    if let location = try? await GeoCoder.createLocationInfo(from: CLLocation.init(latitude: selection.latitude, longitude: selection.longitude)) {
                        setLocation(location)
                    }
                }
            } else {
                location = nil
                animation.distance = 8000
                animation.pitch = 0
            }
        }
    }
    @MainActor private func setLocation(_ location: LocationInfo) {
        animation.distance = 3000
        animation.pitch = 75
        self.location = location
    }
}
