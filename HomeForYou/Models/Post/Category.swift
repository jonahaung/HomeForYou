//
//  GeneralPostType.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/5/23.
//

import SwiftUI
import XUI

enum Category: String, Hashable, Codable, CaseIterable, Equatable, Sendable {
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
            if let rawValue = UserDefaults.standard.string(forKey: K.Defaults.currentCategory.rawValue) {
                return .init(rawValue: rawValue) ?? .rental_room
            }
            return .rental_room
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: K.Defaults.currentCategory.rawValue)
        }
    }
}
