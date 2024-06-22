//
//  Routable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/2/23.
//

import SwiftUI

private struct RoutableButtonPath<Style: PrimitiveButtonStyle>: ViewModifier {
    
    let path: SceneItem
    let style: Style
    @Injected(\.router) private var router
    
    func body(content: Content) -> some View {
        Button {
            router.currentNavRouter?.push(path)
        } label: {
            content
        }
        .buttonStyle(style)
    }
}
private struct RoutableNavPath<Path>: ViewModifier where Path: ViewDisplayable {
    let path: Path
    @Injected(\.router) private var router
    func body(content: Content) -> some View {
        NavigationLink(value: path) {
            content
        }
    }
}
extension View {
    func routable<Style>(to path: SceneItem, style: Style = .borderless) -> some View where Style: PrimitiveButtonStyle {
        ModifiedContent(content: self, modifier: RoutableButtonPath(path: path, style: style))
    }
    func routeToPosts(_ query: CompoundQuery) -> some View {
        self.routable(to: .init(.postCollection, data: query))
    }
    func routeToPosts(_ filters: [PostQuery]) -> some View {
        self.routeToPosts(.init(.accurate, filters))
    }
    
    func routeToPosts(_ filter: PostQuery) -> some View {
        self.routeToPosts(.init(.accurate, [filter]))
    }
    func routableNav<Path>(to path: Path) -> some View where Path: Hashable, Path: ViewDisplayable {
        ModifiedContent(content: self, modifier: RoutableNavPath(path: path))
    }
}
