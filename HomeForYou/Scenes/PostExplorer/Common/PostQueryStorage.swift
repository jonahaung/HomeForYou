//
//  PostQueryStorage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 13/6/24.
//

import Foundation
import XUI
import SwiftUI

class PostQueryStorage: ObservableObject {
    
    @Published var scope = PostExplorer.PostQueryScope.Accurate
    @Published var features = [Feature]()
    @Published var restictions = [Restriction]()
    @Published var priceRange: ClosedRange<Int> = 0...1000
    @Published var quries = [PostQuery]()
    private var cachedValues: [PostKey: String] = [:]
}
extension PostQueryStorage {
    
    func bindableValue(for key: PostKey) -> Binding<String> {
        return .init {
            return self.cachedValues[key] ?? ""
        } set: { [weak self] newValue in
            guard let self else { return }
            cachedValues[key] = newValue
            getPostQuries()
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
}
extension PostQueryStorage {
    func configureDatas(rules: [PostKey]) {
        rules.forEach { each in
            cachedValues[each] = ""
        }
        getPostQuries()
    }
    func updateQueries(queries: [PostQuery]) {
        guard self.quries.isEmpty else { return }
        queries.forEach { each in
            cachedValues[each.key] = each.value
        }
        getPostQuries()
    }
    func clearQueries() {
        switch scope {
        case .Accurate:
            cachedValues.forEach { key, value in
                cachedValues[key] = ""
            }
        case .Possibilities:
            cachedValues.forEach { key, value in
                cachedValues[key] = ""
            }
            restictions.removeAll()
            features.removeAll()
        case .Price:
            priceRange = 0...1000
        }
        getPostQuries()
    }
    private func getPostQuries() {
        var results  = [PostQuery]()
        switch scope {
        case .Accurate:
            for (key, value) in cachedValues {
                results.append(.init(key, value))
            }
        case .Possibilities:
            for (_, value) in cachedValues {
                results.append(.init(.keywords, value))
            }
            results = features.map{ PostQuery(.keywords, $0.rawValue)}
            results.append(contentsOf: restictions.map{ PostQuery(.keywords, $0.rawValue)})
        case .Price:
            let query = PostQuery(.price, "\(priceRange.lowerBound)-\(priceRange.upperBound)")
            results.append(query)
        }
        results.removeAll(where: { query in
            query.value.isWhitespace || query.value == "Any"
        })
        self.quries = results
    }
}
