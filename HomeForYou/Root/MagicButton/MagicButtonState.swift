//
//  MagicButtonState.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/1/24.
//

import Foundation
import SFSafeSymbols
import SwiftUI
import XUI


struct MagicButtonItem {
    
    var symbol: SFSymbol?
    var action: AsyncAction?
    var alignment: Alignment
    var size: CGFloat
    var animations: [PhaseAnimationType] = [.scale(0.9), .scale(1.1)]
    
    init(_ symbol: SFSymbol?, _ alignment: Alignment, _ size: CGFloat = 34.scaled, _ action: (@Sendable () async -> Void)? = nil) {
        self.symbol = symbol
        self.action = action
        self.alignment = alignment
        self.size = size
    }
    mutating func update(symbol: SFSymbol? = nil, alignment: Alignment? = nil, size: CGFloat? = nil, animations: [PhaseAnimationType] = [], action: AsyncAction? = nil) {
        if let symbol {
            self.symbol = symbol
        }
        if let alignment {
            self.alignment = alignment
        }
        if let size {
            self.size = size
        }
        if let action {
            self.action = action
        }
        self.animations = animations
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
            await router.push(to: SceneItem(.postCollection, data: [] as [PostQuery]))
        }
    }()
    static let hidden: MagicButtonItem = {
        .init(nil, .bottom)
    }()
}

extension MagicButtonItem: Hashable, Identifiable {
    var id: String { symbol?.rawValue ?? "" }
    static func == (lhs: MagicButtonItem, rhs: MagicButtonItem) -> Bool {
        lhs.id == rhs.id && lhs.alignment == rhs.alignment && lhs.animations == rhs.animations
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
