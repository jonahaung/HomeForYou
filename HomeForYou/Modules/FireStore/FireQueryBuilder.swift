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

struct FireQueryBuilder {
    
    static func build(
        from query: CompoundQuery,
        category: Category
    ) -> Query {
        let reference = Firestore.firestore().collection(
            category.rawValue
        ) as Query
        var quiche = Quiche<Post>.init(reference)
        switch query {
        case .exactMatch(let array):
            array.sorted().forEach { each in
                quiche = quiche
                    .whereReference(
                        each.key.rawValue,
                        isEqualTo: each.value
                    )
            }
        case .keywords(let array):
            let values = array.map { $0.keyValueString }
            quiche = quiche
                .whereReference(
                    PostKey.keywords.rawValue,
                    arrayContainsAny: values
                )
        case .priceRange(let priceRange):
            let min = priceRange.range.lowerBound
            let max = priceRange.range.upperBound
            quiche = quiche
                .whereReference(
                    PostKey.price.rawValue,
                    isGreaterThanOrEqualTo: min
                )
                .whereReference(
                    PostKey.price.rawValue,
                    isLessThanOrEqualTo: max
                )
        }
        
        return quiche.bake()
    }
}
