//
//  PostUpdateAction.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/6/24.
//

import SwiftUI

struct PostUpdateAction {
    typealias Action = @Sendable (ActionType) async -> ()
    enum ActionType {
        typealias Value = any Postable
        case cancel
        case update(Value)
        case upload(Value)
    }
    let action: Action
    func callAsFunction(_ data: ActionType) async {
        await action(data)
    }
}
struct PostUpdateAction_Key: EnvironmentKey {
    static var defaultValue: PostUpdateAction? = nil
}
extension EnvironmentValues {
    var makeRequestPostUpdate: PostUpdateAction? {
        get { self[PostUpdateAction_Key.self] }
        set { self[PostUpdateAction_Key.self] = newValue }
    }
}
extension View {
    func onRequestPostUpdate(_ action: @escaping PostUpdateAction.Action) -> some View {
        self.environment(\.makeRequestPostUpdate, PostUpdateAction(action: action))
    }
}
