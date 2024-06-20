//
//  CompoundQuery.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/6/24.
//

import Foundation

enum CompoundQuery: Hashable, Sendable {
    case exactMatch([PostQuery])
    case keywords([KeyWord])
    case priceRange(PriceRange)
}
