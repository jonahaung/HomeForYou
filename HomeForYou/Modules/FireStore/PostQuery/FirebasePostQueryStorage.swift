//
//  PostQueryStorage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 13/6/24.
//

import Foundation
import XUI
import SwiftUI

class FirebasePostQueryStorage: ObservableObject {

    @Published var query: CompoundQuery = .init(.accurate, [])
    
    let allowedQueries = [PostKey.propertyType, .roomType, .furnishing, .baths, .beds, .floorLevel, .tenantType, .leaseTerm, .tenure]
}
extension FirebasePostQueryStorage {
    
    func bindableValue(for key: PostKey) -> Binding<String> {
        return .init {
            return self.query.values.first{ $0.key == key }?.value ?? ""
        } set: { newValue in
            var values = self.query.values
            if let i = values.firstIndex(where: { $0.key == key }) {
                values.remove(at: i)
                if newValue.components(separatedBy: ":").last?.isWhitespace == false {
                    values.insert(.init(key, newValue), at: i)
                }
            } else {
                values.append(.init(key, newValue))
            }
            self.query.values = values.sorted()
        }
    }
    var features: Binding<[Feature]> {
        .init {
            let values = self.query.values
            return values.filter{ $0.key == .features }.compactMap{ Feature.init(rawValue: $0.value )}
        } set: { new in
            var filtered = self.query.values.filter{ $0.key != .features }
            filtered.append(contentsOf: new.map{ .init(.features, $0.rawValue)})
            self.query.values = filtered.sorted()
        }
    }
    var restictions: Binding<[Restriction]> {
        .init {
            let values = self.query.values
            return values.filter{ $0.key == .restrictions }.compactMap{ Restriction.init(rawValue: $0.value )}
        } set: { new in
            var filtered = self.query.values.filter{ $0.key != .restrictions }
            filtered.append(contentsOf: new.map{ .init(.restrictions, $0.rawValue)})
            self.query.values = filtered.sorted()
        }
    }
    var priceRange: Binding<ClosedRange<Int>> {
        .init {
            guard
                let value = self.query.values.last
            else {
                return PriceRange.defaultRange(for: .current)
            }
            let strings = value.value.components(separatedBy: "-")
            guard strings.count == 2 else {
                return PriceRange.defaultRange(for: .current)
            }
            guard
                let first = strings.first, let lowerBound = Int(first),
                  let second = strings.last, let upperBound = Int(second),
                  second > first
            else {
                return PriceRange.defaultRange(for: .current)
            }
            return ClosedRange(uncheckedBounds: (lowerBound, upperBound))
        } set: { new in
            let string = "\(new.lowerBound)-\(new.upperBound)"
            let value = PostQuery(.price, string)
            self.query.values = [value]
        }
    }
    func allCases(for key: PostKey) -> [String] {
        switch key {
        case .occupant:
            return Occupant.allCases.map { $0.rawValue }
        case .area:
            return Area.allCases.map { $0.rawValue }
        case .mrt:
            return MRT.allValueStrings
        case .propertyType:
            return PropertyType.allCases.map { $0.rawValue }
        case .roomType:
            return RoomType.allCases.map { $0.rawValue }
        case .furnishing:
            return Furnishing.allCases.map { $0.rawValue }
        case .beds:
            return Bedroom.allCases.map { $0.rawValue }
        case .baths:
            return Bathroom.allCases.map { $0.rawValue }
        case .floorLevel:
            return FloorLevel.allCases.map { $0.rawValue }
        case .tenantType:
            return TenantType.allCases.map { $0.rawValue }
        case .leaseTerm:
            return LeaseTerm.allCases.map { $0.rawValue }
        case .tenure:
            return Tenure.allCases.map { $0.rawValue }
        case .features:
            return Feature.allCases.map { $0.rawValue }
        case .restrictions:
            return Restriction.allCases.map { $0.rawValue }
        case .status:
            return PostStatus.allCases.map { $0.rawValue }
        default:
            fatalError()
        }
    }
    @MainActor func createQuery() -> CompoundQuery {
        let values = self.query.values.filter{ !$0.value.isWhitespace || $0.value != "Any" }
        query.values = values
        return query
    }
}
extension FirebasePostQueryStorage {
    
    func configure(query: CompoundQuery) {
        self.query = query
    }
    func clearQueries() {
        query.values.removeAll()
    }
}
