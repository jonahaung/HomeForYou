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
    var distance: Double = 80000
    var pitch: Double = 0
}
