//
//  TabPath.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import Foundation
import SFSafeSymbols

enum TabItem: String {
    case myItems, createPost, home, more, settings
}
extension TabItem: Identifiable, CaseIterable {
    var id: Self { self }
}

extension TabItem {
    var symbol: SFSymbol {
        switch self {
        case .myItems:
            return .sharedWithYou
        case .createPost:
            return .pencilAndOutline
        case .home:
            return .plusCircleFill
        case .more:
            return .balloon2Fill
        case .settings:
            return .tuningfork
        }
    }
}
