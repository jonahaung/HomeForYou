//
//  HomeSectionHeaderView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import SFSafeSymbols
import XUI

struct HomeSectionHeaderView: View {
    
    private let title: String
    private let symbol: SFSymbol
    private let sceneItem: SceneItem
    
    init(_ title: String, _ symbol: SFSymbol, _ filters: [PostQuery]) {
        self.title = title
        self.symbol = symbol
        self.sceneItem = .init(.postCollection, data: filters)
    }
    init(_ title: String, _ symbol: SFSymbol, _ sceneItem: SceneItem) {
        self.title = title
        self.symbol = symbol
        self.sceneItem = sceneItem
    }
    var body: some View {
        HStack {
            Text(title)
            SystemImage(symbol)
                .foregroundStyle(Color.accentColor)
            Spacer()
            SystemImage(.ellipsis)
                .foregroundStyle(.selection)
                .routable(to: sceneItem)
        }
        .font(.title3.weight(.medium))
        .padding(.horizontal, 8)
        .padding(.top)
    }
}
