//
//  TaskOnce.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/6/24.
//

import SwiftUI

private struct TaskOnceModifier<T: Equatable & Sendable>: ViewModifier {
    
    private let id: T
    private let priority: TaskPriority
    private let action: @Sendable (T) async -> Void
    
    @State private var task: Task<Void, Never>?
    @State private var isFirstTime = true
    
    init(
        id: T,
        priority: TaskPriority = .userInitiated,
        action: @escaping @Sendable (T) async -> Void
    ) {
        self.id = id
        self.priority = priority
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .task {
                guard isFirstTime else { return }
                isFirstTime = false
                self.task = Task(priority: priority) {
                    await action(id)
                }
            }
            .onDisappear {
                self.task?.cancel()
                self.task = nil
            }
            .onChange(of: self.id, debounceTime: .seconds(0.2)) { _, newValue in
                self.task?.cancel()
                self.task = Task(priority: priority) {
                    await action(newValue)
                }
            }
    }
}
public extension View {
    func taskOnce<T: Equatable & Sendable>(id: T, priority: TaskPriority = .high, _ action: @escaping @Sendable (T) async -> Void) -> some View {
        ModifiedContent(content: self, modifier: TaskOnceModifier(id: id, priority: priority, action: action))
    }
}
