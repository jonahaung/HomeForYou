//
//  MagicButtonState.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/1/24.
//

import Foundation
import SFSafeSymbols
import SwiftUI

struct MagicButtonItem {
    
    let symbol: SFSymbol?
    let action: (@Sendable () async -> Void)?
    let alignment: Alignment
    let size: CGFloat
    
    init(_ symbol: SFSymbol?, _ alignment: Alignment, _ size: CGFloat = 34.scaled, _ action: (@Sendable () async -> Void)? = nil) {
        self.symbol = symbol
        self.action = action
        self.alignment = alignment
        self.size = size
    }
    
    static let backButton: MagicButtonItem = {
        .init(.chevronBackwardCircleFill, .bottomLeading) {
            @Injected(\.router) var router
            await router.currentNavRouter?.pop()
        }
    }()
    
    static let explorer: MagicButtonItem = {
        .init(.magnifyingglassCircleFill, .bottom, 54.scaled) {
            @Injected(\.router) var router
            await router.push(to: SceneItem(.postCollection, data: [] as [PostFilter]))
        }
    }()
    static let hidden: MagicButtonItem = {
        .init(nil, .bottom, 0)
    }()
}

extension MagicButtonItem: Hashable, Identifiable {
    var id: String { symbol?.rawValue ?? "" }
    static func == (lhs: MagicButtonItem, rhs: MagicButtonItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
