//
//  MapKeyFrameAnimation.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 9/6/24.
//

import Foundation
import CoreLocation

struct MapKeyFrameAnimation: Hashable, Equatable {
    
    var coordinate: CLLocationCoordinate2D?
    var distance: Double?
    var pitch: Double?
    
    init(_ coordinate: CLLocationCoordinate2D? = .singapore, distance: Double? = 80000, pitch: Double? = nil) {
        self.coordinate = coordinate
        self.distance = distance
        self.pitch = pitch
    }
}
extension CLLocationCoordinate2D {
    static let singapore: CLLocationCoordinate2D = .init(latitude: 1.3521, longitude: 103.8198)
}
