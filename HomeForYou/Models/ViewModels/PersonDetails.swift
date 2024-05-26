//
//  PersonDetails.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/3/23.
//

import Foundation
import XUI

final class PersonDetails: ObservableObject, @unchecked Sendable {

    @Published var person = Person()
    @Published var rating: CGFloat = 2.5
    private var task: Task<(), Never>?

    init(_ person: Person) {
        self.person = person
    }
    init(_ id: String) {
        person.id = id
        fetch()
    }

    deinit {
        task?.cancel()
    }
}

extension PersonDetails {
    private func fetch() {
        guard task == nil else { return }
        guard person.isValid else { return }
        let id = person.id
        if let existing = MemoryCache.value(Person.self, key: id) {
            person = existing
        } else {
            task = Task {
                if Task.isCancelled { return }
                do {
                    let item = try await Repo.async_fetch(path: Person.collectionID, for: id, as: Person.self)
                    MemoryCache.cache(id, value: item)
                    if Task.isCancelled { return }
                    self.person = item
                    self.task = nil
                } catch {
                    Log(error)
                }
            }
        }
    }
}
