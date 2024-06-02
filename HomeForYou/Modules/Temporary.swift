//
//  Temporary.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import SwiftUI

public extension Color {
    static let systemGroupedBackground = Color(uiColor: .systemGroupedBackground)
}

extension AttributedString: Identifiable {
    public var id: AttributedString { self }
}

public extension AttributedString {
    var string: String {
        NSAttributedString(self).string
    }
}
