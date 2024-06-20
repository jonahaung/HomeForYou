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
                    .foregroundStyle(.tint)
                    .shadow(color: .primary.opacity(0.2), radius: 2)
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
            .frame(square: viewModel.item.size)
            .padding()
            .animation(.snappy(duration: 0.5).delay(0.2), value: viewModel.item.alignment)
        }
        .buttonStyle(.plain)
        .offset(y: viewModel.item.alignment == .bottom ? -30 : 0)
        .zIndex(5)
        
    }
}
