//
//  MagicButton+ViewModifier.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/1/24.
//

import SwiftUI
import XUI

private struct MagicButtonStateModifier: ViewModifier {
    
    @Environment(MagicButtonViewModel.self) private var viewModel
    @Binding var item: MagicButtonItem
    
    func body(content: Content) -> some View {
        content
            .task(id: item, debounceTime: .seconds(0.7)) {
                await MainActor.run {
                    viewModel.item = item
                    withAnimation {
                        if viewModel.item.alignment != .bottom {
                            viewModel.tabBarVisibility = .hidden
                        } else {
                            viewModel.tabBarVisibility = .visible
                        }
                    }
                }
            }
            
    }
}
extension View {
    func magicButton(_ item: Binding<MagicButtonItem>) -> some View {
        modifier(MagicButtonStateModifier(item: item))
    }
}
