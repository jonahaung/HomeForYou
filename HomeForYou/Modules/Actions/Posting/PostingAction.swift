//
//  PostingAction.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/6/24.
//

import SwiftUI


struct PostingAction {
    enum ActionType {
        typealias T = any Postable
        case cancel
        case update(T)
        case upload(T)
    }
    typealias Action = @Sendable (ActionType) async -> ()
    let action: Action
    func callAsFunction(_ data: ActionType) async {
        await action(data)
    }
}
struct PostingActionKey: EnvironmentKey {
    static var defaultValue: PostingAction? = nil
}
extension EnvironmentValues {
    var onTakePostingAction: PostingAction? {
        get { self[PostingActionKey.self] }
        set { self[PostingActionKey.self] = newValue }
    }
}
extension View {
    func onTakePostingAction(_ action:  @escaping PostingAction.Action) -> some View {
        self.environment(\.onTakePostingAction, PostingAction(action: action))
    }
}
