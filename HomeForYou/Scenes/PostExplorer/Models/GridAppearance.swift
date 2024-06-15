//
//  ExplorerAappearance.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/3/23.
//

import SwiftUI

class GridAppearance: ObservableObject {
    @AppStorage("gridStyle") var gridStyle = GridStyle.Large
    
    func handleOnTap() {
        let allStyles = GridStyle.allCases
        let currentStyle = gridStyle
        if (allStyles.firstIndex(of: currentStyle) != nil) {
            if currentStyle == allStyles.last {
                self.gridStyle = allStyles.first!
            } else if currentStyle == allStyles.first {
                self.gridStyle = allStyles[1]
            } else {
                self.gridStyle = allStyles.last!
            }
        }
    }
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
            return "rectangle.split.1x2"
        case .TwoCol:
            return "rectangle.split.2x2"
        case .Large:
            return "rectangle"
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
