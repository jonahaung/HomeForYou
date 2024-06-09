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
