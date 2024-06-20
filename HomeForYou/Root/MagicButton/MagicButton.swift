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
        AsyncButton(actionOptions: []) {
            await viewModel.item.action?()
        } label: {
            ZStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .equatable(by: viewModel.item.alignment)
                    .animation(.snappy(duration: 0.3), value: viewModel.item.alignment)
                    .foregroundStyle(Color.accentColor.gradient)
                    .shadow(color: .secondary.opacity(0.4), radius: 2)
                if let symbolName = viewModel.item.symbol?.rawValue {
                    Image(systemName: symbolName)
                        .resizable()
                        .scaledToFill()
                        .symbolEffect(.bounce, value: viewModel.item.animations.count)
                        .symbolRenderingMode(.monochrome)
                        .phaseAnimation(viewModel.item.animations)
                        .foregroundStyle(Color(uiColor: .systemBackground).gradient)
                        .frame(square: viewModel.item.size/2)
                }
            }
        }
        .buttonStyle(.plain)
        .offset(y: viewModel.item.alignment == .bottom ? -30 : 0)
        .frame(square: viewModel.item.size)
        .zIndex(5)
        .padding(.horizontal)
    }
}
