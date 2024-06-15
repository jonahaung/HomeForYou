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
            AsyncButton(actionOptions: []) {
                _Haptics.play(.soft)
                 try await viewModel.item.action?()
            } label: {
                SystemImage(symbol, viewModel.item.size)
                    .symbolRenderingMode(.multicolor)

            }
            .foregroundStyle(Gradient(colors: [.accentColor,  Color.accentColor.opacity(0.8), .accentColor]))
            .contentTransition(.symbolEffect)
            .offset(y: viewModel.item.alignment == .bottom ? -30 : 0)
            .phaseAnimation(viewModel.item.animations)
            .animation(.smooth, value: viewModel.item.alignment)
            .padding(.horizontal)
            .equatable(by: viewModel.item)
        }
    }
}
