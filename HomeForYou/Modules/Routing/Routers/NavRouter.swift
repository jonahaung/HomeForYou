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
    @MainActor func popToRoot(andPush item: SceneItem)
    @MainActor func push(_ destination: SceneItem)
    @MainActor func push(_ destinations: [SceneItem])
}

extension NavPathRepresentable {
    
}

@Observable
final class NavRouter: Identifiable, NavPathRepresentable {
    
    let tab: TabItem
    var path = [SceneItem]()
    private let lock = RecursiveLock()
    init(_ tab: TabItem) {
        self.tab = tab
    }
    
    @MainActor
    func pop(_ count: Int = 1) {
        lock.sync {
            guard count <= path.count else {
                path = .init()
                return
            }
            path.removeLast(count)
        }
    }
    @MainActor
    func popToRoot() {
        lock.sync {
            path.removeAll()
        }
    }
    @MainActor
    func popToRoot(andPush item: SceneItem) {
        pop()
        lock.sync {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.path.append(item)
            }
        }
    }
    @MainActor
    func push(_ destination: SceneItem) {
        lock.sync {
            if let index = path.firstIndex(where: { view in
                view.id == destination.id
            }) {
                path = Array(path[0...index])
            } else {
                path.append(destination)
            }
        }
    }
    @MainActor
    func push(_ destinations: [SceneItem]) {
        lock.sync {
            for destination in destinations {
                path.append(destination)
            }
        }
    }
    @MainActor
    func set(_ destinations: [SceneItem]) {
        lock.sync {
            path = destinations
        }
    }
}
