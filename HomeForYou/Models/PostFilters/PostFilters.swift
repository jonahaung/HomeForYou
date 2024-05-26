//
//  PostFilters.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/5/23.
//

import Foundation
import FirebaseFirestore

struct PostFilters: Hashable, Codable {

    var category = Category.current
    var propertyType = PropertyType.Any
    var area = Area.Any
    var isPriceRange: Bool = false
    var priceRange: ClosedRange<Int> = 0...1000
    var roomType = RoomType.Any
    var occupant = Occupant.Any
    var furnishing = Furnishing.Any
    var tenantType = TenantType.Any
    var leaseTerm = LeaseTerm.Any
    var tenure = Tenure.Any
    var features = [Feature]()
    var restrictions = [Restriction]()
    var mrt = String()
    var postal = String()
    var geoHash = String()
    var bedroom = Bedroom.Any
    var bathroom = Bathroom.Any
    var floorLevel = FloorLevel.Any
    var views = String()
    var favourites = String()
    var author = String()
    var status = PostStatus.Any
    var keywords = [KeyWord]()

    init(_ filters: [PostFilter], category: Category) {
        self.category = category
        filters.forEach { each in
            let values = each.values
            var joinedValue: String {
                values.joined().trimmingCharacters(in: .whitespacesAndNewlines)
            }
            switch each.postKey {
            case .price:
                if let vOne = values.first?.parseToInt(), let v2 = values.last?.parseToInt() {
                    priceRange = (min(vOne, v2)...max(vOne, v2))
                }
            case .area:
                area = .init(rawValue: joinedValue) ?? .Any
            case .mrt:
                mrt = joinedValue
            case .occupant:
                occupant = .init(rawValue: joinedValue) ?? .Any
            case .postal:
                postal = joinedValue
            case .geoHash:
                geoHash = joinedValue
            case .propertyType:
                propertyType = .init(rawValue: joinedValue) ?? .Any
            case .roomType:
                roomType = .init(rawValue: joinedValue) ?? .Any
            case .furnishing:
                furnishing = .init(rawValue: joinedValue) ?? .Any
            case .beds:
                bedroom = .init(rawValue: joinedValue) ?? .Any
            case .baths:
                self.bathroom = .init(rawValue: joinedValue) ?? .Any
            case .floorLevel:
                floorLevel = .init(rawValue: joinedValue) ?? .Any
            case .tenantType:
                tenantType = .init(rawValue: joinedValue) ?? .Any
            case .leaseTerm:
                leaseTerm = .init(rawValue: joinedValue) ?? .Any
            case .tenure:
                tenure = .init(rawValue: joinedValue) ?? .Any
            case .features:
                features = values.compactMap{ .init(rawValue: $0) }
            case .restrictions:
                restrictions = values.compactMap{ .init(rawValue: $0) }
            case .status:
                status = .init(rawValue: joinedValue) ?? .Any
            case .views:
                views = joinedValue
            case .favourites:
                favourites = joinedValue
            case .author:
                author = joinedValue
            case .keywords:
                keywords = values.compactMap{ .init(keyValueString: $0) }
            default:
                break
            }
        }
    }

    func createQuery() -> Query {
        return QueryBuilder.createQuery(from: .init(getFilters(), category: category))
    }

    func getFilters() -> [PostFilter] {
        var filters = [PostFilter]()
        if status != .Any {
            filters.append(.init(.status, [status.rawValue]))
        }
        if propertyType != .Any {
            filters.append(.init(.propertyType, [propertyType.rawValue]))
        }
        if isPriceRange {
            return [.init(.price, [priceRange.lowerBound.description, priceRange.upperBound.description])]
        }
        if roomType != .Any {
            filters.append(.init(.roomType, [roomType.rawValue]))
        }
        if area != .Any {
            filters.append(.init(.area, [area.rawValue]))
        }
        if occupant != .Any {
            filters.append(.init(.occupant, [occupant.rawValue]))
        }
        if !mrt.isWhitespace {
            filters.append(.init(.mrt, [mrt]))
        }
        if !postal.isWhitespace {
            filters.append(.init(.postal, [postal]))
        }
        if !geoHash.isWhitespace {
            filters.append(.init(.geoHash, [geoHash]))
        }
        if furnishing != .Any {
            filters.append(.init(.furnishing, [furnishing.rawValue]))
        }
        if bedroom != .Any {
            filters.append(.init(.beds, [bedroom.rawValue]))
        }
        if bathroom != .Any {
            filters.append(.init(.baths, [bathroom.rawValue]))
        }
        if floorLevel != .Any {
            filters.append(.init(.floorLevel, [floorLevel.rawValue]))
        }
        if tenantType != .Any {
            filters.append(.init(.tenantType, [tenantType.rawValue]))
        }
        if leaseTerm != .Any {
            filters.append(.init(.leaseTerm, [leaseTerm.rawValue]))
        }
        if tenure != .Any {
            filters.append(.init(.tenure, [tenure.rawValue]))
        }
        if !features.isEmpty {
            filters.append(.init(.features, features.map{ $0.rawValue }))
        }
        if !restrictions.isEmpty {
            filters.append(.init(.restrictions, restrictions.map{ $0.rawValue}))
        }
        if !views.isEmpty {
            filters.append(.init(.views, [views]))
        }
        if !favourites.isEmpty {
            filters.append(.init(.favourites, [favourites]))
        }
        if !author.isEmpty {
            filters.append(.init(.author, [author.id]))
        }
        if !keywords.isEmpty {
            filters.append(.init(.keywords, keywords.map{ $0.keyValueString }))
        }
        return filters.uniqued().sorted()
    }
    var isEmpty: Bool { self == .init([], category: .current) }
    mutating func clear() {
        self = .init([], category: self.category)
    }
}

struct PostSort: Hashable, Codable {

    enum SortKey: String, Codable {
        case createdAt, price, none
    }

    var key: SortKey
    var isDecending: Bool

    var isEmpty: Bool { key == .none }
}
