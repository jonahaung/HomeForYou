//
//  LocationMapItem.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/24.
//

import SwiftUI
import CoreLocation

protocol LocationMapPresentable: Hashable, Identifiable {
    var title: String { get }
    var subtitle: String { get }
    var coordinate: CLLocationCoordinate2D { get }
}
extension LocationMapPresentable {
    var id: String { title + subtitle }
}
extension LocationMapPresentable {
    static func centerCoordinate(for items: [any LocationMapPresentable]) -> CLLocationCoordinate2D {
        let region = PolygonRegion(verticies: items.compactMap{ $0.coordinate })
        return region.center
    }
}

struct LocationMapItem: LocationMapPresentable {
    var title: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    var color: Color?
}

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
