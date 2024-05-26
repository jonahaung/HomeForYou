//
//  CurrentLocationAction.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/5/24.
//

import SwiftUI

struct CategoryAction {
    typealias Action = @Sendable (Category) async -> ()
    let action: Action
    func callAsFunction(_ data: Category) async {
        await action(data)
    }
}
struct CategoryActionKey: EnvironmentKey {
    static var defaultValue: CategoryAction? = nil
}
extension EnvironmentValues {
    var onUpdateCategory: CategoryAction? {
        get { self[CategoryActionKey.self] }
        set { self[CategoryActionKey.self] = newValue }
    }
}
extension View {
    func onUpdateCategory(_ action:  @escaping CategoryAction.Action) -> some View {
        self.environment(\.onUpdateCategory, CategoryAction(action: action))
    }
}
