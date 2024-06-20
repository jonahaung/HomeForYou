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
    var action: (@MainActor() async -> Void)?
    var alignment: Alignment
    var size: CGFloat = 50
    var animations: [PhaseAnimationType] = []
    
    init(_ symbol: SFSymbol?, _ alignment: Alignment, size: CGFloat? = nil, animations: [PhaseAnimationType] = [], _ action: (@MainActor () async -> Void)? = nil) {
        self.symbol = symbol
        self.action = action
        self.alignment = alignment
        if let size {
            self.size = size
        }
        self.animations = animations
    }
}
extension MagicButtonItem {
    mutating func update(symbol: SFSymbol? = nil, alignment: Alignment? = nil, animations: [PhaseAnimationType] = [], action: (() async -> Void)?) {
        var weakSelf = self
        weakSelf.symbol = symbol ?? self.symbol
        weakSelf.alignment = alignment ?? self.alignment
        weakSelf.action = action
        weakSelf.animations = animations
        self = weakSelf
    }
}
extension MagicButtonItem {
    static let backButton: MagicButtonItem = {
        .init(.arrowshapeBackwardFill, .bottomLeading) {
            @Injected(\.router) var router
            router.currentNavRouter?.pop()
        }
    }()
    static let explorer: MagicButtonItem = {
        .init(.signpostRightAndLeftFill, .bottom, size: 55, animations: [.scale(0.7), .scale(1)]) {
            @Injected(\.router) var router
            router.push(to: SceneItem(.postCollection, data: [] as [PostQuery]))
        }
    }()
    static let hidden: MagicButtonItem = {
        .init(nil, .bottom)
    }()
}
extension MagicButtonItem: Hashable, Identifiable {
    var id: String { symbol?.rawValue ?? "" + animations.count.description}
    static func == (lhs: MagicButtonItem, rhs: MagicButtonItem) -> Bool {
        lhs.id == rhs.id && lhs.alignment == rhs.alignment && lhs.animations == rhs.animations
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
