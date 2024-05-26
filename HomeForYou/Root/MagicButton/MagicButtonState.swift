//
//  MagicButtonState.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/1/24.
//

import Foundation
import SFSafeSymbols
import SwiftUI

struct MagicButtonItem: Hashable, Identifiable {
    
    let symbol: SFSymbol
    let action: (@Sendable () async -> Void)?
    let alignment: Alignment
    
    init(_ symbol: SFSymbol, _ alignment: Alignment, _ action: (@Sendable () async -> Void)? = nil) {
        self.symbol = symbol
        self.action = action
        self.alignment = alignment
    }
    
    var id: SFSymbol { symbol }
    static func == (lhs: MagicButtonItem, rhs: MagicButtonItem) -> Bool {
        lhs.symbol == rhs.symbol
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let backButton: MagicButtonItem = {
        .init(.chevronBackwardCircleFill, .bottomLeading) {
            @Injected(\.router) var router
            await router.currentNavRouter?.pop()
        }
    }()
    
    static let explorer: MagicButtonItem = {
        .init(.magnifyingglassCircleFill, .bottom) {
            @Injected(\.router) var router
            await router.push(to: SceneItem(.postCollection, data: [] as [PostFilter]))
        }
    }()
    var size: CGFloat {
        alignment == .bottom ? 54 : 34
    }
}
