//
//  KeyWord.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/4/23.
//

import Foundation

struct KeyWord: Codable, Hashable, Identifiable {
    
    var id: String { keyValueString }
    let key: PostKeys
    var value: String
    
    var rawValue: String { keyValueString }
    
    init(_ key: PostKeys, _ value: String) {
        self.key = key
        self.value = value
    }
    
    static func keyWord(for key: PostKeys, to post: any Postable) -> [KeyWord] {
        switch key {
        case .category:
            return [.init(key, post.category.rawValue)]
        case .id:
            return [.init(key, post.id)]
        case .autherID:
            return [.init(key, post.author.id)]
        case .phoneNumber:
            return [.init(key, post.phoneNumber)]
        case .price:
            return [.init(key, post.price.description)]
        case .occupant:
            return [.init(key, post._occupant.rawValue)]
        case .area:
            return [.init(key, post.area.rawValue)]
        case .mrt:
            return [.init(key, post.mrt)]
        case .postal:
            return [.init(key, post.postalCode)]
        case .locationInfo:
            return [.init(key, post.geoHash)]
        case .propertyType:
            return [.init(key, post.propertyType.rawValue)]
        case .roomType:
            return [.init(key, post._roomType.rawValue)]
        case .furnishing:
            return [.init(key, post._furnishing.rawValue)]
        case .beds:
            return [.init(key, post.beds.rawValue)]
        case .baths:
            return [.init(key, post.baths.rawValue)]
        case .floorLevel:
            return [.init(key, post.floorLevel.rawValue)]
        case .tenantType:
            return [.init(key, post._tenantType.rawValue)]
        case .leaseTerm:
            return [.init(key, post._leaseTerm.rawValue)]
        case .tenure:
            return [.init(key, post._tenure.rawValue)]
        case .location:
            return [.init(key, post.geoHash)]
        case .features:
            return post.features.map { $0.keyword() }
        case .restrictions:
            return post.restrictions.map { $0.keyword()  }
        default:
            return []
        }
    }
    
    var keyValueString: String {
        "\(key.rawValue):\(value)"
    }
    
    var localizedString: String {
        "\(value.title) \(key.localized)"
    }
    init?(keyValueString: String) {
        let strings = keyValueString.components(separatedBy: ":")
        guard
            let keyString = strings[safe: 0],
            let key = PostKeys(rawValue: keyString),
            let value = strings[safe: 1]
        else {
            return nil
        }
        self.init(key, value)
    }
    
    static let all: [KeyWord] = {
        var keywords = [KeyWord]()
        let mrts = MRT.allValueStrings.map { KeyWord(.mrt, $0)}
        let areas = Area.allCases.map { KeyWord(.area, $0.rawValue) }
        let features = Feature.allCases.map { KeyWord(.favourites, $0.rawValue) }
        let restrictions = Restriction.allCases.map { KeyWord(.restrictions, $0.rawValue) }
        keywords = mrts + areas + features + restrictions
        return keywords.uniqued()
    }()
}
