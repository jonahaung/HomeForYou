//
//  PlanningArea.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import Foundation
import CoreLocation

struct PlanningArea: Hashable, Identifiable {
    
    static func == (lhs: PlanningArea, rhs: PlanningArea) -> Bool {
        lhs.id == rhs.id
    }
    var id: String { name + geometry.id }
    let name: String
    let geometry: XGeometry
    func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
    }
    enum XGeometry: Identifiable {
        case polygon([CLLocationCoordinate2D])
        case multiPolygon([[CLLocationCoordinate2D]])
        var id: String {
            switch self {
            case .polygon(let array):
                return "\(array.count)"
            case .multiPolygon(let array):
                return "\(array.count)"
            }
        }
        var centerCoordinates: [CLLocationCoordinate2D] {
            var items = [CLLocationCoordinate2D]()
            switch self {
            case .polygon(let coordinates):
                let lattitude = coordinates.map({ $0.latitude }).reduce(Double.zero) { partialResult, next in
                    partialResult + next
                }
                let longitude = coordinates.map{ $0.longitude }.reduce(Double.zero) { partialResult, next in
                    partialResult + next
                }
                let divider = Double(coordinates.count)
                let coordinate = CLLocationCoordinate2D(latitude: lattitude/divider, longitude: longitude/divider)
                items.append(coordinate)
            case .multiPolygon(let array):
                array.forEach { coordinates in
                    let latitude = coordinates.map({ $0.latitude }).reduce(Double.zero) { partialResult, next in
                        partialResult + next
                    }
                    let longitude = coordinates.map{ $0.longitude }.reduce(Double.zero) { partialResult, next in
                        partialResult + next
                    }
                    let divider = Double(coordinates.count)
                    let coordinate = CLLocationCoordinate2D(latitude: latitude/divider, longitude: longitude/divider)
                    items.append(coordinate)
                }
            }
            return items
        }
        
        var regions: [PolygonRegion] {
            switch self {
            case .polygon(let array):
                return [.init(verticies: array)]
            case .multiPolygon(let array):
                return array.map{ PolygonRegion(verticies: $0 )}
            }
        }
        
        func isContain(_ coordinate: CLLocationCoordinate2D) -> Bool {
            switch self {
            case .polygon(let array):
                let points = array.map{ CGPoint.init(x: $0.latitude, y: $0.longitude) }
                let point = CGPoint(x: coordinate.latitude, y: coordinate.longitude)
                return point.isInsidePolygon(polygon: points)
            case .multiPolygon(let array):
                var isContains = false
                array.forEach { each in
                    let points = each.map{ CGPoint.init(x: $0.latitude, y: $0.longitude) }
                    let point = CGPoint(x: coordinate.latitude, y: coordinate.longitude)
                    if !isContains {
                        isContains = point.isInsidePolygon(polygon: points)
                    }
                }
                return isContains
            }
        }
    }
    
    static let items: [PlanningArea] = {
        return PlanningAreaParser.load()
    }()
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
