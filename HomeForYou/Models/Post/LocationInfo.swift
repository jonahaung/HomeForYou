//
//  LocationInfo.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/5/23.
//

import Foundation
import CoreLocation
import MapKit

struct LocationInfo: Codable, Hashable {

    static let empty = LocationInfo(
        area: .Any,
        nearestMRT: .init(mrt: "", distance: 0),
        address: .init(text: "", postal: ""),
        geoInfo: .init(
            latitude: 1.3124740687274035,
            longitude: 103.8963501183422,
            geoHash: ""
        )
    )
    var area: Area
    var nearestMRT: LocationInfo.NearestMRT
    var address: LocationInfo.Address
    var geoInfo: LocationInfo.GeoInfo

    var isValid: Bool {
        address.isValid && nearestMRT.isValid && geoInfo.isValid
    }

    var isEmpty: Bool {
        address.postal.isWhitespace
    }
}

extension LocationInfo {

    struct Address: Codable, Hashable {
        var text: String
        var postal: String
        var isValid: Bool { !text.isEmpty && postal.isPostalCode }
    }

    struct NearestMRT: Codable, Hashable, Sendable {
        var mrt: String
        var distance: Int
        var isValid: Bool { !mrt.isEmpty && distance != 0 }
    }

    struct GeoInfo: Codable, Hashable, Sendable {
        var latitude: Double
        var longitude: Double
        var geoHash: String

        var isValid: Bool { !geoHash.isEmpty }
        var coordinate: CLLocationCoordinate2D {
            get {
                CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            set {
                latitude = newValue.latitude
                longitude = newValue.longitude
                geoHash = newValue.geohash(length: 6)
            }
        }
        var location: CLLocation { CLLocation.init(latitude: latitude, longitude: longitude)}
        var region: MKCoordinateRegion {
            MKCoordinateRegion(
                center: coordinate,
                span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
    }
}

private extension String {
    var isPostalCode: Bool {
        guard self.count == 6 else {
            return false
        }
        guard Int(self) != nil else {
            return false
        }
        return true
    }
}
