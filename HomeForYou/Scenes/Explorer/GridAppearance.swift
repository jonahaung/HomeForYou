//
//  ExplorerAappearance.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/3/23.
//

import SwiftUI

class GridAppearance: ObservableObject {
    @AppStorage("gridStyle") var gridStyle = GridStyle.Large
}

enum GridStyle: String, CaseIterable, Hashable, Identifiable {
    var id: String { self.rawValue }
    case List, TwoCol, Large

    var columns: Int {
        if self == .TwoCol {
            return 2
        }
        return 1
    }

    var spacing: CGFloat {
        switch self {
        case .List:
            return 1
        case .TwoCol:
            return 3
        case .Large:
            return 15
        }
    }
    var iconName: String {
        switch self {
        case .List:
            return "blinds.horizontal.closed"
        case .TwoCol:
            return "rectangle.grid.2x2.fill"
        case .Large:
            return "rectangle.grid.1x2.fill"
        }
    }
    var title: String {
        switch self {
        case .List:
            return "List"
        case .TwoCol:
            return "Square"
        case .Large:
            return "Large"
        }
    }
}
