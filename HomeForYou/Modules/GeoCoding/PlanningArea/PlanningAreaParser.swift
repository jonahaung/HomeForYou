//
//  PlanningAreaParser.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import UIKit
import CoreLocation

internal class PlanningAreaParser {
    
    static func load() -> [PlanningArea] {
        guard let asset = NSDataAsset(name: "planning_area", bundle: Bundle.main),
              let json = try? JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments),
              let jsonDict = json as? JsonDictionary else {
            return []
        }
        return PlanningAreaParser().parse(json: jsonDict)
    }
    
    
    typealias JsonDictionary = [String: Any]
    func parse(json: JsonDictionary) -> [PlanningArea] {
        guard let features = json["features"] as? [JsonDictionary] else {
            return []
        }
        return features.compactMap(self.parseCountry)
    }
    
    private func parseCountry(country: JsonDictionary) -> PlanningArea? {
        guard
            let properties = country["properties"] as? JsonDictionary,
            let countryName = properties["name"] as? String,
            let geometryDict = country["geometry"] as? JsonDictionary,
            let geoType = geometryDict["type"] as? String else {
            return nil
        }
        
        if geoType == "Polygon" {
            return PlanningArea(name: countryName, geometry: .polygon(self.parsePolygon(json: geometryDict)))
        } else if geoType == "MultiPolygon" {
            return PlanningArea(name: countryName, geometry: .multiPolygon(self.parseMultiPolygon(json: geometryDict)))
        } else {
            return nil
        }
    }
    
    private func parsePolygon(json: JsonDictionary) -> [CLLocationCoordinate2D] {
        guard let coordinates = json["coordinates"] as? [[[Double]]] else {
            return []
        }
        return self.parsePoints(points: coordinates)
    }
    
    private func parseMultiPolygon(json: JsonDictionary) -> [[CLLocationCoordinate2D]] {
        guard let coordinates = json["coordinates"] as? [[[[Double]]]] else {
            return []
        }
        
        return coordinates.map(self.parsePoints)
    }
    
    private func parsePoints(points: [[[Double]]]) -> [CLLocationCoordinate2D] {
        return points.flatMap{ $0 }.compactMap({ point in
            guard let longitude = point.first, let latitude = point.last else {
                return nil
            }
            return .init(latitude: latitude, longitude: longitude)
        })
    }
}

