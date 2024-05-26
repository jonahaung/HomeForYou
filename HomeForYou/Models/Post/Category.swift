//
//  GeneralPostType.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/5/23.
//

import SwiftUI
import XUI

enum Category: String, Hashable, Codable, CaseIterable, Sendable {
    
    var id: String { rawValue }
    
    case selling, rental_flat, rental_room
    
    var title: String {
        switch self {
        case .selling:
            return "Selling"
        case .rental_flat:
            return "Home Rental"
        case .rental_room:
            return "Room Rental"
        }
    }
    static var current: Category {
        get {
            if let x = UserDefaults.standard.string(forKey: "category") {
                return .init(rawValue: x) ?? .rental_room
            }
            return .rental_room
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "category")
        }
    }
    
//    enum Environment: EnvironmentKey {
//        static var defaultValue: Category = .rental_room
//    }
}

//extension Category: PreferenceKey {
//    static var defaultValue: Category = .rental_room
//    static func reduce(value: inout Category, nextValue: () -> Category) {
//        value = nextValue()
//    }
//}
//
//extension EnvironmentValues {
//    var category: Category {
//        get { self[Category.Environment.self] }
//        set { self[Category.Environment.self] = newValue }
//    }
//}
