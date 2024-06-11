//
//  ThemedNavView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/4/23.
//

import SwiftUI
import XUI
import SwiftyTheme

private struct ThemedNavView<Content: View>: View {
    private let content: Content

    init(content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        NavigationStack {
            content
        }
        .swiftyThemeStyle()
        .ignoresSafeArea(.keyboard)
    }
}

private struct EmbeddedInNavigationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ThemedNavView {
            content
        }
    }
}

public extension View {
    func embeddedInNavigationView() -> some View {
        ModifiedContent(content: self, modifier: EmbeddedInNavigationViewModifier())
    }
}
