//
//  PlanningArea.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import Foundation
import CoreLocation

struct PlanningArea: Sendable {
    var rawValue: String { name }
    let name: String
    let geometry: Geometry
    
    init(name: String, geometry: Geometry) {
        self.name = name
        self.geometry = geometry
    }
}
extension PlanningArea {
    enum Geometry: Identifiable {
        case polygon(PolygonRegion)
        case multiPolygon([PolygonRegion])
        var id: AnyHashable {
            switch self {
            case .polygon(let array):
                return array.id
            case .multiPolygon(let array):
                return array.count
            }
        }
        var centerCoordinate: CLLocationCoordinate2D {
            switch self {
            case .polygon(let region):
                return region.center
            case .multiPolygon(let regions):
                let region = PolygonRegion(verticies: regions.flatMap{ $0.verticies })
                return region.center
            }
        }
        
        func isContain(_ coordinate: CLLocationCoordinate2D) -> Bool {
            switch self {
            case .polygon(let region):
                return region.isPointInside(coordinate)
            case .multiPolygon(let regions):
                return regions.first(where: { $0.isPointInside(coordinate) }) != nil
            }
        }
    }
}
extension PlanningArea {
    init?(_ coordinate: CLLocationCoordinate2D) {
        if let item = Self.allCases.first(where: { $0.geometry.isContain(coordinate) }) {
            self = item
        } else {
            return nil
        }
    }
    
    init?(_ area: Area) {
        let name = area.rawValue.replace("_", with: " ").uppercased()
        if let found = Self.allCases.first(where: { $0.name == name }) {
            self = found
        } else {
            return nil
        }
    }
}
extension PlanningArea: CaseIterable {
    static let allCases: [PlanningArea] = PlanningAreaParser.load()
    var area: Area {
        let rawValue = name.replace(" ", with: "_").capitalized
        return .init(rawValue: rawValue)!
    }
}
extension PlanningArea: Hashable, Identifiable {
    var id: AnyHashable { name }
    static func == (lhs: PlanningArea, rhs: PlanningArea) -> Bool {
        lhs.name == rhs.name && lhs.geometry.id == rhs.geometry.id
    }
    func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
    }
}
