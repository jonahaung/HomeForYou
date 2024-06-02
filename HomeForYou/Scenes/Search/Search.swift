//
//  Search.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import SwiftUI
import XUI

enum Search {
    
    enum ResultType: Hashable, Identifiable {
        var id: Self { self }
        case suggestions
        case emptyResults
        case results([AttributedString])
        case location(LocationInfo)
    }
    
    enum SuggestionType: Hashable, Identifiable {
        var id: Self { self }
        case currentLocation, locationOnMap
        case recentSearches([KeyWord])
        
        var description: String {
            switch self {
            case .currentLocation:
                return "Use my current location"
            case .locationOnMap:
                return "Set location on map"
            case .recentSearches:
                return "Recent searches"
            }
        }
    }
    
    struct Result: Hashable, Identifiable {
        var id: String { keyword.id }
        var attributedString: AttributedString
        var keyword: KeyWord
    }
    
    enum Scope: String, Identifiable, CaseIterable {
        var id: String { rawValue }
        case Address, MRT, Area, Keyword
        
        static var current: Scope {
            get {
                let rawValue = UserDefaults.standard.string(forKey: K.Defaults.currentSearchScope.rawValue) ?? ""
                return .init(rawValue: rawValue) ?? .Address
            }
            set {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: K.Defaults.currentSearchScope.rawValue)
            }
        }
    }
}
