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
    var action: (@MainActor () async throws -> Void)?
    var alignment: Alignment
    var size: CGFloat
    var animations: [PhaseAnimationType] = [.scale(0.9), .scale(1.1)]
    
    init(_ symbol: SFSymbol?, _ alignment: Alignment, _ size: CGFloat = 34.scaled, _ action: (() async -> Void)? = nil) {
        self.symbol = symbol
        self.action = action
        self.alignment = alignment
        self.size = size
    }
    mutating func update(symbol: SFSymbol? = nil, alignment: Alignment? = nil, size: CGFloat? = nil, animations: [PhaseAnimationType] = [], action: @escaping (@MainActor () async throws -> Void)) {
        var weakSelf = self
        weakSelf.symbol = symbol ?? self.symbol
        weakSelf.alignment = alignment ?? self.alignment
        weakSelf.size = size ?? self.size
        weakSelf.action = action
        weakSelf.animations = animations.isEmpty ? self.animations : animations
        self = weakSelf
    }
    mutating func updateAction(action: @escaping (@MainActor () async throws -> Void)) {
        self.update(size: size, action: action)
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
    mutating
    func loading(_ isLoading: Bool, action: @escaping (@MainActor () async throws -> Void)) {
        let symbol = isLoading ? SFSymbol.arrowTriangle2CirclepathCircleFill : .line2HorizontalDecreaseCircleFill
        let size = isLoading ? CGFloat(34) : 38
        let alignment = isLoading ? Alignment.center : .trailing
        self.update(symbol: symbol, alignment: alignment, size: size, animations: isLoading ? [.rotate(.north), .rotate(.north_360)] : [.scale(1), .scale(1.1)], action: action)
    }
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
