//
//  Looking.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/6/23.
//

import Foundation
import FireAuthManager

class Looking: Repoable, ObservableObject {
    static let collectionPath = "looking"
    var collectionPath: String { "looking" }
    
    var id = Looking.createID()
    var category: Category
    var authorID = String()
    var author: PersonInfo
    var title = String() { willSet { updateUI() } }
    var description = String() { willSet { updateUI() } }
    var price_max: Int = 0 { willSet { updateUI() } }
    var occupant: Occupant? { willSet { updateUI() } }
    var propertyType: PropertyType = .Any { willSet { updateUI() } }
    var roomType: RoomType = .Any { willSet { updateUI() } }
    var status = PostStatus.Available { willSet { updateUI() } }
    var createdAt: Date = .now { willSet { updateUI() } }
    var mrts = [String]() { willSet { updateUI() } }
    var targetedDate = Date.now { willSet { updateUI() } }
    var phone = "" { willSet { updateUI() }}
    
    init(category: Category) {
        self.category = category
        @Injected(\.currentUser) var currentUser
        self.author = .init(model: currentUser.model ?? .init())
    }
}

extension Looking {
    var _occupant: Occupant {
        get { occupant ?? .Any }
        set { occupant = newValue == .Any ? nil : newValue }
    }
    var _propertyType: PropertyType {
        get { propertyType }
        set { propertyType = newValue }
    }
    
    func updateUI() {
        DispatchQueue.safeAsync { [weak self] in
            self?.objectWillChange.send()
        }
    }
}

extension Looking: Equatable, Identifiable {
    static func == (lhs: Looking, rhs: Looking) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
