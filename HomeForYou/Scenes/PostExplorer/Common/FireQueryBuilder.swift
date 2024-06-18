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
    
    static func configure(
        _ query: PostQuery,
        quiche: inout Quiche<Post>
    ) {
        let postKey = query.key
        let key = postKey.rawValue
        let value = query.value
        
        switch postKey {
        case .price:
            let range = value.components(
                separatedBy: "-"
            )
            let min = range.first?.parseToInt() ?? 0
            let max = range.last?.parseToInt() ?? 100000
            quiche = quiche
                .whereReference(
                    PostKey.price.rawValue,
                    isGreaterThanOrEqualTo: min
                )
                .whereReference(
                    PostKey.price.rawValue,
                    isLessThanOrEqualTo: max
                )
        case .keywords:
            let values = value.components(
                separatedBy: "|"
            )
            print(values)
            quiche = quiche
                .whereReference(
                    PostKey.keywords.rawValue,
                    arrayContainsAny: values
                )
        case .favourites, .views:
            quiche = quiche
                .whereReference(
                    key,
                    arrayContains: value
                )
        default:
            quiche = quiche
                .whereReference(
                    key,
                    isEqualTo: value
                )
        }
    }
    
    static func build(
        from queries: [PostQuery],
        category: Category
    ) -> Query {
        let reference = Firestore.firestore().collection(
            category.rawValue
        ) as Query
        var quiche = Quiche<Post>.init(
            reference
        )
        queries.sorted().forEach { each in
            configure(
                each,
                quiche: &quiche
            )
        }
        return quiche.bake()
    }
}
