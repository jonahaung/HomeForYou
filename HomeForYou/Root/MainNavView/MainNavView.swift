//
//  MainNavView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import SwiftUI

struct MainNavView<Content: View>: View {
    
    @State private var router: NavRouter
    private let content: Content

    init(_ router: @autoclosure () -> NavRouter, @ViewBuilder content: @escaping () -> Content) {
        self._router = .init(wrappedValue: router())
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: SceneItem.self) {
                    $0.viewToDisplay
                        .toolbar(.hidden, for: .tabBar)
                }
                .environment(router)
                .toolbar(.visible, for: .tabBar)
        }
    }
}
