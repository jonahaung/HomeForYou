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

struct FirebaseQueryBuilder {
    
    static func build(
        from query: CompoundQuery,
        category: Category
    ) -> Query {
        let reference = Firestore.firestore().collection(
            category.rawValue
        ) as Query
        var quiche = Quiche<Post>.init(reference)
        switch query.queryType {
        case .accurate:
            let array = query.values
            array.sorted().forEach { each in
                quiche = quiche
                    .whereReference(
                        each.key.rawValue,
                        isEqualTo: each.value
                    )
            }
        case .keywords:
            let array = query.values
            if !array.isEmpty {
                let values = array.map { KeyWord($0.key, $0.value) }.map { $0.keyValueString }.uniqued().sorted()
                quiche = quiche
                    .whereReference(
                        PostKey.keywords.rawValue,
                        arrayContainsAny: values
                    )
            }
        case .priceRange:
            guard let first = query.values.first(where: { $0.key == .price }) else { return quiche.bake() }
            let valueString = first.value
            let strings = valueString.components(separatedBy: "")
            guard let lowerBound = strings.first?.parseToInt(), let upperBound = strings.last?.parseToInt() else { return quiche.bake() }
            quiche = quiche
                .whereReference(
                    PostKey.price.rawValue,
                    isGreaterThanOrEqualTo: lowerBound
                )
                .whereReference(
                    PostKey.price.rawValue,
                    isLessThanOrEqualTo: upperBound
                )
        }
        
        return quiche.bake()
    }
}
