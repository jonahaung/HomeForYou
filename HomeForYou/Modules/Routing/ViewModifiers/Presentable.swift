//
//  Presentable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 23/1/24.
//

import SwiftUI

enum PresentScreenKind {
    case sheet, fullScreenCover
}
private struct PresentableModifer: ViewModifier {
    
    let screen: SceneItem
    let style: PresentScreenKind
    @Injected(\.router) private var router
    
    func body(content: Content) -> some View {
        Button {
            switch style {
            case .sheet:
                router.presentSheet(screen)
            case .fullScreenCover:
                router.presentFullScreen(screen)
            }
        } label: {
            content
        }
    }
}
private struct RoutableNavPath<Path>: ViewModifier where Path: ViewDisplayable {
    let path: Path
    func body(content: Content) -> some View {
        NavigationLink(value: path) {
            content
        }
    }
}
extension View {
    func presentable(_ screen: SceneItem, _ style: PresentScreenKind) -> some View {
        ModifiedContent(content: self, modifier: PresentableModifer(screen: screen, style: style))
    }
}
