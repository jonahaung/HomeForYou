//
//  SearchAction.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 8/6/24.
//

import SwiftUI

struct SearchAction {
    enum ActionItem {
        case mrtMap, areaMap, locationPickerMap, exploreAllPost
        case filter([PostFilter])
    }
    typealias Action = @Sendable (ActionItem) async -> ()
    let action: Action
    func callAsFunction(_ data: ActionItem) async {
        await action(data)
    }
}
struct SearchActionKey: EnvironmentKey {
    static var defaultValue: SearchAction? = nil
}
extension EnvironmentValues {
    var onSearchAction: SearchAction? {
        get { self[SearchActionKey.self] }
        set { self[SearchActionKey.self] = newValue }
    }
}
extension View {
    func onSearchSubmit(_ action:  @escaping SearchAction.Action) -> some View {
        self.environment(\.onSearchAction, SearchAction(action: action))
    }
}
