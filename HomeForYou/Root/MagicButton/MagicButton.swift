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
                    .animation(.snappy(duration: 0.3), value: viewModel.item.alignment)
                    .foregroundStyle(Color.accentColor.gradient)
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
                        .symbolRenderingMode(.palette)
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
