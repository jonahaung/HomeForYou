//
//  NavRouter.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import SwiftUI
import XUI

protocol NavPathRepresentable: AnyObject {
    var path: [SceneItem] { get set }
    @MainActor func pop(_ count: Int)
    @MainActor func popToRoot()
    @MainActor func push(_ destination: SceneItem)
    @MainActor func push(_ destinations: [SceneItem])
}

extension NavPathRepresentable {
    @MainActor
    func pop(_ count: Int = 1) {
        guard count <= path.count else {
            path = .init()
            return
        }
        path.removeLast(count)
    }
    @MainActor
    func popToRoot() {
        path = .init()
    }
    @MainActor
    func push(_ destination: SceneItem) {
        if let index = path.firstIndex(where: { view in
            view.id == destination.id
        }) {
            path = Array(path[0...index])
        } else {
            path.append(destination)
        }
    }
    @MainActor
    func push(_ destinations: [SceneItem]) {
        for destination in destinations {
            path.append(destination)
        }
    }
}

@Observable
final class NavRouter: Identifiable, NavPathRepresentable {
    
    let tab: TabItem
    var path = [SceneItem]()
    
    init(_ tab: TabItem) {
        self.tab = tab
    }
}
