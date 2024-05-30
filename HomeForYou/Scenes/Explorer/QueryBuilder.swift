//
//  QueryCreater.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/5/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import XUI

struct QueryBuilder {

    static func configure(_ each: PostFilter, reference: inout Query) {
        let postKey = each.postKey
        let key = postKey.rawValue
        let values = each.values
    
        switch postKey {
        case .price:
            break
        case .keywords:
            reference = reference.whereField(
                key, arrayContainsAny: values.suffix(10)
            )
        case .features, .restrictions:
            reference = reference.whereField(
                key, arrayContainsAny: values.suffix(10)
            )
        case .favourites, .views:
            let valueString = values.joined().trimmed
            reference = reference.whereField(key, arrayContains: valueString)
        default:
            if values.count == 1 {
                let valueString = values.joined().trimmed
                reference = reference.whereField(key, isEqualTo: valueString)
            } else {
                reference.whereField(key, arrayContains: values)
            }
        }
        
//        switch each {
//        case .auther(let string):
//            reference = reference.whereField(key, isEqualTo: string)
//        case .phoneNumber(let string):
//            reference = reference.whereField(key, isEqualTo: string)
//        case .price:
//            break
//        case .occupatnt(let occupant):
//            reference = reference.whereField(key, isEqualTo: occupant.rawValue)
//        case .area(let area):
//            reference = reference.whereField(key, isEqualTo: area.rawValue)
//        case .mrt(let string):
//            reference = reference.whereField(key, isEqualTo: string)
//        case .postal(let string):
//            reference = reference.whereField(key, isEqualTo: string)
//        case .geoHash(let string):
//            reference = reference.whereField(key, isEqualTo: string)
//        case .propertyType(let propertyType):
//            reference = reference.whereField(key, isEqualTo: propertyType.rawValue)
//        case .roomType(let roomType):
//            reference = reference.whereField(key, isEqualTo: roomType.rawValue)
//        case .furnishing(let furnishing):
//            reference = reference.whereField(key, isEqualTo: furnishing.rawValue)
//        case .beds(let bedroom):
//            reference = reference.whereField(key, isEqualTo: bedroom.rawValue)
//        case .baths(let bathroom):
//            reference = reference.whereField(key, isEqualTo: bathroom.rawValue)
//        case .floorLevel(let floorLevel):
//            reference = reference.whereField(key, isEqualTo: floorLevel.rawValue)
//        case .tenantType(let tenantType):
//            reference = reference.whereField(key, isEqualTo: tenantType.rawValue)
//        case .leaseTerm(let leaseTerm):
//            reference = reference.whereField(key, isEqualTo: leaseTerm.rawValue)
//        case .tenure(let tenure):
//            reference = reference.whereField(key, isEqualTo: tenure.rawValue)
//        case .features(let features):
//            keyWords.append(contentsOf: features.map { KeyWord(.features, $0.title )})
//        case .restrictions(let restrictions):
//            keyWords.append(contentsOf: restrictions.map { KeyWord(.restrictions, $0.title )})
//        case .status(let status):
//            reference = reference.whereField(key, isEqualTo: status.rawValue)
//        case .keywords(let array):
//            keyWords.append(contentsOf: array)
//        case .views(let string):
//            reference = reference.whereField(key, arrayContains: string)
//        case .favourites(let string):
//            reference = reference.whereField(key, arrayContains: string)
//        }
    }

    static func createQuery(from postFilters: PostFiltersGroup) -> Query {
        if postFilters.isPriceRange {
            let priceRange = postFilters.priceRange
            let key = PostKeys.price.rawValue
            return Firestore.firestore()
                .collection(postFilters.category.rawValue)
                .whereField(key, isGreaterThanOrEqualTo: priceRange.lowerBound)
                .whereField(key, isLessThanOrEqualTo: priceRange.upperBound)
        }

        var reference = Firestore.firestore().collection(postFilters.category.rawValue) as Query
        postFilters.getFilters().sorted().forEach { each in
            configure(each, reference: &reference)
        }
        return reference
    }
}
