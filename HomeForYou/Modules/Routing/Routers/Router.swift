//
//  Router.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import SwiftUI
import XUI

@Observable
final class Router: ViewModel {
    
    var fullScreenCovers = [SceneItem]()
    var sheets = [SceneItem]()
    var tabPath: TabItem = .home
    
    let navRouters = TabItem.allCases.map{ NavRouter($0) }
    
    var alert: XUI._Alert?
    var loading: Bool = false
}
extension Router {
    @MainActor
    func tab(to newTab: TabItem) {
        guard tabPath != newTab else {
            currentNavRouter?.pop()
            return
        }
        tabPath = newTab
    }
    @MainActor
    func push(to screen: SceneItem) {
        currentNavRouter?.push(screen)
    }
    @MainActor
    func presentFullScreen(_ screen: SceneItem) {
        fullScreenCovers.append(screen)
    }
    @MainActor
    func presentSheet(_ screen: SceneItem) {
        sheets.append(screen)
    }
}
extension Router {
    func checkSetupStatus() {
        if !Onboarding.hasShown {
            fullScreenCovers.append(.init(.onboarding))
        }
    }
}
extension Router {
    private func navRouter(for tab: TabItem) -> NavRouter? {
        navRouters.first(where: { $0.tab == tabPath} )
    }
    var currentNavRouter: NavRouter? { navRouter(for: tabPath) }
}
