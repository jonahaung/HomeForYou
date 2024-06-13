//
//  MRT+Extensions.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/2/23.
//

import Foundation
import CoreLocation

extension MRT {
    
    var coordinate: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude)}
    var location: CLLocation { .init(latitude: latitude, longitude: longitude) }
    
    
}
