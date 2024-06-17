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
    var size: CGFloat
    var animations: [PhaseAnimationType] = []
    
    init(_ symbol: SFSymbol?, _ alignment: Alignment, _ size: CGFloat = 34.scaled, _ action: (@MainActor () async -> Void)? = nil) {
        self.symbol = symbol
        self.action = action
        self.alignment = alignment
        self.size = size
    }
}
extension MagicButtonItem {
    mutating func update(symbol: SFSymbol? = nil, alignment: Alignment? = nil, size: CGFloat? = nil, animations: [PhaseAnimationType] = [], action: (() async -> Void)?) {
        var weakSelf = self
        weakSelf.symbol = symbol ?? self.symbol
        weakSelf.alignment = alignment ?? self.alignment
        weakSelf.size = size ?? self.size
        weakSelf.action = action
        weakSelf.animations = animations
        self = weakSelf
    }
    mutating
    func loading(_ isLoading: Bool, action: @escaping (@MainActor () async -> Void)) {
        let symbol = isLoading ? SFSymbol.arrowTriangle2CirclepathCircleFill : .line3HorizontalDecreaseCircleFill
        let size = isLoading ? CGFloat(34) : 38
        let alignment = isLoading ? Alignment.center : .trailing
        self.update(symbol: symbol, alignment: alignment, size: size, animations: isLoading ? [.rotate(.north), .rotate(.north_360)] : [.scale(0.9), .scale(1)], action: action)
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
        .init(.signpostRightAndLeft, .bottom, 50.scaled) {
            @Injected(\.router) var router
            router.push(to: SceneItem(.postCollection, data: [] as [PostQuery]))
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
