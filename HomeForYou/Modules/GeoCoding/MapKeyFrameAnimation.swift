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
    
    init(_ coordinate: CLLocationCoordinate2D? = nil, distance: Double? = nil, pitch: Double? = nil) {
        self.coordinate = coordinate
        self.distance = distance
        self.pitch = pitch
    }
}
