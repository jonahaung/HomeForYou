//
//  AnnotationItem.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/2/23.
//

import SwiftUI
import MapKit

struct GeoLocation: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var location: CLLocation { CLLocation.init(latitude: latitude, longitude: longitude)}
}
extension GeoLocation {
    init(coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}
