//
//  KeywordsFactory.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/6/24.
//

import Foundation

struct KeywordsFactory  {
    
    func keywords(for post: any Postable) -> [KeyWord] {
        var results = [KeyWord]()
        PostKey.allCases.forEach { postKey in
            switch postKey {
            case .category:
                results.append(.init(postKey, post.category.rawValue))
            case .id:
                results.append(.init(postKey, post.id))
            case .autherID:
                results.append(.init(postKey, post.author.id))
            case .phoneNumber:
                results.append(.init(postKey, post.author.phoneNumber.str))
            case .price:
                results.append(.init(postKey, post.price.description))
            case .occupant:
                if let occupant = post.occupant {
                    results.append(.init(postKey, occupant.rawValue))
                }
            case .area:
                results.append(.init(postKey, post.area.rawValue))
            case .mrt:
                results.append(.init(postKey, post.mrt))
            case .postal:
                results.append(.init(postKey, post.postalCode))
            case .locationInfo:
                results.append(.init(postKey, post.geoHash))
            case .propertyType:
                results.append(.init(postKey, post.propertyType.rawValue))
            case .roomType:
                if let roomType = post.roomType {
                    results.append(.init(postKey, roomType.rawValue))
                }
            case .furnishing:
                if let furnishing = post.furnishing {
                    results.append(.init(postKey, furnishing.rawValue))
                }
            case .beds:
                results.append(.init(postKey, post.beds.rawValue))
            case .baths:
                results.append(.init(postKey, post.baths.rawValue))
            case .floorLevel:
                results.append(.init(postKey, post.floorLevel.rawValue))
            case .tenantType:
                if let tenantType = post.tenantType {
                    results.append(.init(postKey, tenantType.rawValue))
                }
            case .leaseTerm:
                if let leaseTerm = post.leaseTerm {
                    results.append(.init(postKey, leaseTerm.rawValue))
                }
            case .tenure:
                if let tenure = post.tenure {
                    results.append(.init(postKey, tenure.rawValue))
                }
            case .location:
                results.append(.init(postKey, post.geoHash))
            case .features:
                results.append(contentsOf: post.features.map{ KeyWord(postKey, $0.rawValue)})
            case .restrictions:
                results.append(contentsOf: post.restrictions.map{ KeyWord(postKey, $0.rawValue)})
            case .mrtDistance:
                results.append(.init(postKey, "\(post.mrtDistance) mins to \(post.mrt) MRT"))
            case .status:
                results.append(.init(postKey, post.status.rawValue))
            default:
                break
            }
        }
        return results
    }
}
