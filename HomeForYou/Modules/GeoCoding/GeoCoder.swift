//
//  PostalCode.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/5/23.
//

import Foundation
import MapKit

struct GeoCoder {

    static func createLocationInfo(_ postalCode: String) async throws -> LocationInfo {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = postalCode
        let response = try await MKLocalSearch(request: request).start()
        let placemarks = response.mapItems.map { $0.placemark }
        let region = response.boundingRegion

        guard
            let placemark = placemarks.last,
            let mrtResult = MRT.closestMRT(from: .init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude))
        else {
            throw XError.unknownError
        }
        let addressText = generateAddress(placemark: placemark)
        let mrt = mrtResult.mrt
        let location = GeoLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        let area: Area = {
            for each in Area.allCases {
                let text = each.title.trimmed
                if text == mrt {
                    return each
                } else if addressText.lowercased().contains(text.lowercased()) {
                    return each
                }
            }
            return .Any
        }()

        let address = LocationInfo.Address(text: addressText, postal: postalCode)
        let geoHash = location.coordinate.geohash(precision: .twentyFourHundredMeters)
        let geoInfo = LocationInfo.GeoInfo(latitude: location.latitude, longitude: location.longitude, geoHash: geoHash)
        return LocationInfo(area: area, nearestMRT: mrtResult, address: address, geoInfo: geoInfo)
    }

    static func createLocationInfo(from location: CLLocation) async throws -> LocationInfo {
        let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
        guard !placemarks.isEmpty, let postalCode = placemarks.first?.postalCode else {
            throw XError.unwrapping
        }
        return try await GeoCoder.createLocationInfo(postalCode)
    }

    static func createLocationInfo(from adedressText: String) async throws -> LocationInfo {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = adedressText
        let response = try await MKLocalSearch(request: request).start()
        let region = response.boundingRegion
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        return try await createLocationInfo(from: location)
    }

    private static func generateAddress(placemark: CLPlacemark) -> String {
        var components = [String]()

        if let x = placemark.subThoroughfare {
            components.append(x)
        }
        if let x = placemark.thoroughfare, x != placemark.name {
            components.append(x)
        }

        if let x = placemark.subLocality {
            components.append(x)
        }
        if let x = placemark.locality {
            components.append(x)
        }

        if let x = placemark.postalCode {
            components.append(x)
        }
        if let x = placemark.administrativeArea {
            components.append(x)
        }
        return components.joined(separator: ", ")
    }
    
    static func address(from postalCode: String) async throws -> Address {
        let postString = "{\"postalCode\":\""+postalCode+"\"}"
        let url = URL(string: "https://stg.transitlink.com.sg/eservice_admin/mobile/conc_address.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("text/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UInt(postString.count))", forHTTPHeaderField: "Content-length")
        request.httpBody = postString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let dic = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { throw XError.jSONSerialization }
        let block = dic["blockNo"] as? String ?? ""
        let streetName = dic["streetName"] as? String ?? ""
        let buildingName = dic["buildingName"] as? String ?? ""
        return Address(title: buildingName.trimmed.capitalized, subtitle: "\(block) \(streetName)".trimmed, postalCode: postalCode)
    }
}
