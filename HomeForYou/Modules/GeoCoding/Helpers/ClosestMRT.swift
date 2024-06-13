//
//  ClosestMRT.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/6/24.
//

import Foundation
import CoreLocation

enum ClosestMRT {
    static func closestMRT(from location: CLLocation) -> LocationInfo.NearestMRT {
        let mrts = MRT.allValues
        var closestMRT: MRT?
        var smallestDistance: CLLocationDistance?
        for mrt in mrts {
            let mrtLocation = mrt.location
            let distance = location.distance(from: mrtLocation)
            
            if smallestDistance == nil || distance < smallestDistance ?? .init() {
                closestMRT = mrt
                smallestDistance = distance
            }
        }
        if let closestMRT, let smallestDistance {
            return .init(mrt: closestMRT.name, distance: smallestDistance.minutes)
        }
        return .init(mrt: closestMRT?.name ?? "", distance: 0)
    }
}
