//
//  PostExplorer.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import Foundation

enum PostExplorer {
    static let Posts_Fetch_Limit = 6
    static let Stretchy_Header_Height = CGFloat(320)
    
    enum FilterType: Hashable, Identifiable, CaseIterable {
        case exactMatch
        case keywords
        case priceRange
        
        var title: String {
            switch self {
            case .exactMatch:
                return "Matched"
            case .keywords:
                return "Coontains any"
            case .priceRange:
                return "Price Range"
            }
        }
        var id: String { title }
    }
}
