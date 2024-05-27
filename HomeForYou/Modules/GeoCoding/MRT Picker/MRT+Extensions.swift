//
//  MRT+Extensions.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/2/23.
//

import Foundation
import CoreLocation

extension MRT {

    var coordinate: CLLocationCoordinate2D { .init(latitude: self.latitude, longitude: self.longitude)}
    var location: CLLocation { CLLocation.init(latitude: latitude, longitude: longitude) }

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
            return .init(mrt: closestMRT.name, distance: smallestDistance.seconds / 60)
        }
        return .init(mrt: closestMRT?.name ?? "", distance: 0)
    }
}

extension TimeInterval {
    var seconds: Int {
        return Int(self.rounded())
    }
    var milliseconds: Int {
        return Int(self * 1_000)
    }
}
