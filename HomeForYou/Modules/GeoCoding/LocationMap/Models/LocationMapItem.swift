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

struct LocationMapItem: LocationMapPresentable {
    var id = UUID()
    var title: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    var color: Color?
    
    static func centerCoordinate(for items: [Self]) -> CLLocationCoordinate2D {
        guard items.count > 0 else {
            return CLLocationCoordinate2D(latitude: 1.3124740687274035, longitude: 103.8963501183422)
        }
        let lat = items.map{ $0.coordinate.latitude }.reduce(Double.zero) { result, element in
            result + element
        }
        let long = items.map{ $0.coordinate.longitude }.reduce(Double.zero) { result, element in
            result + element
        }
        return .init(latitude: lat/items.count.double, longitude: long/items.count.double)
    }
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
