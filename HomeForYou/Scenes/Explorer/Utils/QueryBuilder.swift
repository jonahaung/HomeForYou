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
    
    static func configure(_ query: PostQuery, quiche: inout Quiche) {
        let postKey = query.key
        let key = postKey.rawValue
        let value = query.value
        switch postKey {
        case .price:
            let range = value.components(separatedBy: "-")
            let min = range.first?.parseToInt() ?? 0
            let max = range.last?.parseToInt() ?? 10000000000
            quiche = quiche.where(key, isGreaterThan: min.description)
            quiche = quiche.where(key, isLessThanOrEqualTo: max.description)
        case .features, .restrictions, .keywords:
            let values = value.components(separatedBy: "|")
            quiche = quiche.where(key, arrayContainsAny: values)
        case .favourites, .views:
            quiche = quiche.where(key, arrayContains: value)
        default:
            quiche = quiche.where(key, isEqualTo: value)
        }
    }
    
    static func createQuery(from queries: [PostQuery], category: Category) -> Query {
        let reference = Firestore.firestore().collection(category.rawValue) as Query
        var quiche = Quiche.init(reference)
        queries.sorted().forEach { each in
            configure(each, quiche: &quiche)
        }
        return quiche.bake()
    }
}
