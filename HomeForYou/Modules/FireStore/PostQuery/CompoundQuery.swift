//
//  CompoundQuery.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/6/24.
//

import SwiftUI

struct CompoundQuery: Hashable, Sendable {
      
    var queryType: QueryType
    var values: [PostQuery]
    
    init(_ queryType: QueryType, _ values: [PostQuery]) {
        self.queryType = queryType
        self.values = values
    }
}

extension CompoundQuery: Identifiable {
    enum QueryType: String, Sendable, CaseIterable, Identifiable {
        case accurate, keywords, priceRange
        var title: String { rawValue }
        var id: String {
            title
        }
        func hash(into hasher: inout Hasher) {
            id.hash(into: &hasher)
        }
    }
    var id: QueryType { queryType }
}
