//
//  PriceRange.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 22/7/23.
//

import Foundation
import XUI

struct PriceRange: Hashable, Sendable {
    var range: ClosedRange<Int> = 50000...10000000
    static func defaultRange(
        for category: Category
    ) -> ClosedRange<Int> {
        switch category {
        case .selling:
            return 50000...10000000
        case .rental_flat:
            return 1000...10000
        case .rental_room:
            return 200...5000
        }
    }

    static func defaultSteps(for category: Category) -> Double {
        switch category {
        case .selling:
            return 10000
        case .rental_flat:
            return 300
        case .rental_room:
            return 100
        }
    }

    static func integerRange(
        for doubleRange: ClosedRange<Int>
    ) -> ClosedRange<Int> {
        Int(
            doubleRange.lowerBound
        )...Int(
            doubleRange.upperBound
        )
    }
}
