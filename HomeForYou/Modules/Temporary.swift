//
//  Temporary.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import SwiftUI

public extension Color {
    static let systemGroupedBackground = Color(uiColor: .systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(uiColor: .secondarySystemGroupedBackground)
}
extension AttributedString: Identifiable {
    public var id: AttributedString { self }
}
public extension AttributedString {
    var string: String {
        NSAttributedString(self).string
    }
}
public extension Array {
    var middle: Element? {
        guard count != 0 else { return nil }
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
}
public extension TimeInterval {
    var minutes: Int { Int(rounded()/60) }
    var seconds: Int { Int(rounded()) }
    var milliseconds: Int { Int(self * 1_000) }
}
public extension CGPoint {
    func isInsidePolygon(polygon: [CGPoint]) -> Bool {
        var pJ = polygon.last!
        var contains = false
        for pI in polygon {
            if ( ((pI.y >= self.y) != (pJ.y >= self.y)) &&
                 (self.x <= (pJ.x - pI.x) * (self.y - pI.y) / (pJ.y - pI.y) + pI.x) ){
                contains = !contains
            }
            pJ=pI
        }
        return contains
    }
}
public typealias StringAny = [String: Any]
