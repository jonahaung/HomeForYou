//
//  MagicButton+ViewModifier.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/1/24.
//

import SwiftUI

private struct MagicButtonStateModifier: ViewModifier {
    
    @Environment(MagicButtonViewModel.self) private var viewModel
    let item: MagicButtonItem

    func body(content: Content) -> some View {
        content
            .onAppear {
                viewModel.item = item
            }
    }
}

extension View {
    func magicButton(_ item: MagicButtonItem) -> some View {
        modifier(MagicButtonStateModifier(item: item))
    }
}
