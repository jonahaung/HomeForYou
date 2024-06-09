//
//  PlanningArea.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import Foundation
import CoreLocation

struct PlanningArea: Sendable {
    static let items: [PlanningArea] = {
        return PlanningAreaParser.load()
    }()
    
    let name: String
    let geometry: XGeometry
    
    init(name: String, geometry: XGeometry) {
        self.name = name
        self.geometry = geometry
    }
    
    init?(_ coordinate: CLLocationCoordinate2D) {
        if let item = Self.items.first(where: { $0.geometry.isContain(coordinate) }) {
            self = item
        } else {
            return nil
        }
    }
    
    init?(_ area: Area) {
        let name = area.rawValue.replace("_", with: " ").uppercased()
        if let found = Self.items.first(where: { $0.name == name }) {
            self = found
        } else {
            return nil
        }
    }
    var area: Area {
        let rawValue = name.replace(" ", with: "_").capitalized
        return .init(rawValue: rawValue)!
    }
    enum XGeometry: Identifiable {
        
        case polygon(PolygonRegion)
        case multiPolygon([PolygonRegion])
        
        var id: AnyHashable {
            switch self {
            case .polygon(let array):
                if array.verticies.isEmpty {
                    return ""
                }
                return array.id
            case .multiPolygon(let array):
                return "\(array.count)"
            }
        }
        var centerCoordinates: [CLLocationCoordinate2D] {
            var items = [CLLocationCoordinate2D]()
            switch self {
            case .polygon(let region):
                items.append(region.center)
            case .multiPolygon(let regions):
                regions.forEach { region in
                    items.append(region.center)
                }
            }
            return items
        }
        
        func isContain(_ coordinate: CLLocationCoordinate2D) -> Bool {
            switch self {
            case .polygon(let region):
                return region.isPointInside(coordinate)
            case .multiPolygon(let regions):
                return regions.contains(where: { $0.isPointInside(coordinate)})
            }
        }
    }
}
extension PlanningArea: Hashable, Identifiable {
    var id: AnyHashable { name }
    static func == (lhs: PlanningArea, rhs: PlanningArea) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
    }
}
extension CGPoint {
    func isInsidePolygon(polygon: [CGPoint]) -> Bool {
        var pJ = polygon.last!
        var contains = false
        for pI in polygon {
            if ( ((pI.y >= self.y) != (pJ.y >= self.y)) &&
                 (self.x <= (pJ.x - pI.x) * (self.y - pI.y) / (pJ.y - pI.y) + pI.x) ){
                contains = !contains
            }
            pJ=pI
        }
        return contains
    }
}
