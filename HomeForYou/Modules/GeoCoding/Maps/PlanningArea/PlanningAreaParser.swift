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
        guard let asset = NSDataAsset(name: "planning_area", bundle: .main),
              let json = try? JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments),
              let jsonDict = json as? [String: Any] else {
            return []
        }
        return PlanningAreaParser.parse(json: jsonDict)
    }
    static func parse(json: StringAny) -> [PlanningArea] {
        guard let features = json["features"] as? [StringAny] else {
            return []
        }
        return features.compactMap(self.parse)
    }
    
    private static func parse(dic: StringAny) -> PlanningArea? {
        guard
            let properties = dic["properties"] as? StringAny,
            let name = properties["name"] as? String,
            let geometryDict = dic["geometry"] as? StringAny,
            let geoType = geometryDict["type"] as? String else {
            return nil
        }
        if geoType == "Polygon" {
            return PlanningArea(name: name, geometry: .polygon(.init(verticies: parsePolygon(json: geometryDict))))
        } else if geoType == "MultiPolygon" {
            return PlanningArea(name: name, geometry: .multiPolygon(parseMultiPolygon(json: geometryDict).map{ .init(verticies: $0)}))
        } else {
            return nil
        }
    }
    
    private static func parsePolygon(json: StringAny) -> [CLLocationCoordinate2D] {
        guard let coordinates = json["coordinates"] as? [[[Double]]] else {
            return []
        }
        return self.parsePoints(points: coordinates)
    }
    
    private static func parseMultiPolygon(json: StringAny) -> [[CLLocationCoordinate2D]] {
        guard let coordinates = json["coordinates"] as? [[[[Double]]]] else {
            return []
        }
        return coordinates.map(self.parsePoints)
    }
    
    private static func parsePoints(points: [[[Double]]]) -> [CLLocationCoordinate2D] {
        return points.flatMap{ $0 }.compactMap({ point in
            guard let longitude = point.first, let latitude = point.last, longitude != latitude else {
                return nil
            }
            return .init(latitude: latitude, longitude: longitude)
        })
    }
}
