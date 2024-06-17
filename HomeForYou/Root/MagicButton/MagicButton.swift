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
    @State private var symbolName: String?
    var body: some View {
        AsyncButton(actionOptions: []) {
            await viewModel.item.action?()
        } label: {
            ZStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .equatable(by: viewModel.item.alignment)
                    .animation(.smooth(duration: 0.3), value: viewModel.item.alignment)
                    .foregroundStyle(.tint)
                    .onChange(of: viewModel.item) { _, newValue in
                        symbolName = nil
                        DispatchQueue.delay {
                            symbolName = newValue.symbol?.rawValue
                        }
                    }
                if let symbolName {
                    Image(systemName: symbolName)
                        .resizable()
                        .scaledToFill()
                        .phaseAnimation(viewModel.item.animations)
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.white)
                        .frame(square: viewModel.item.size/2)
                }
            }
        }
        .buttonStyle(.plain)
        .offset(y: viewModel.item.alignment == .bottom ? -30 : 0)
        .frame(square: viewModel.item.size)
        .padding(.horizontal)
    }
}
