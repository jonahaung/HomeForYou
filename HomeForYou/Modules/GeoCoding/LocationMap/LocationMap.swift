//
//  LocationMap.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/2/24.
//

import SwiftUI
import MapKit
import XUI

struct LocationMap<Item: LocationMapPresentable>: View {
    
    private var items: [Item]
    @State var selected: Item?
    @State private var position: MapCameraPosition
    @State private var lookAroundScene: MKLookAroundScene?
    
    init(_ items: [Item]) {
        position = .item(.init(placemark: .init(coordinate: items.middle?.coordinate ?? .init())))
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
            MapCompass()
            MapScaleView()
        }
        .onChange(of: selected, initial: false, { _,_  in
            if let selected {
                Task {
                    let request = MKLookAroundSceneRequest(coordinate: selected.coordinate)
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
