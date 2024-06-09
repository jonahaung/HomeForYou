//
//  MainTabBarCenterButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 13/1/24.
//

import SwiftUI
import XUI

struct MagicButton: View {
    
    @Environment(MagicButtonViewModel.self) private var viewModel
    
    var body: some View {
        if let symbol = viewModel.item.symbol {
            AsyncButton {
                _Haptics.play(.soft)
                await viewModel.item.action?()
            } label: {
                SystemImage(symbol, viewModel.item.size)
                    .symbolRenderingMode(.multicolor)
            }
            .fontWeight(.light)
            .foregroundStyle(Color.accentColor.gradient)
            .contentTransition(.symbolEffect)
            .offset(y: viewModel.item.alignment == .bottom ? -30 : 0)
            .animation(.smooth, value: viewModel.item.alignment)
            .phaseAnimation([.scale(0.9), .scale(1.1)])
            .padding(.horizontal)
        }
    }
}
