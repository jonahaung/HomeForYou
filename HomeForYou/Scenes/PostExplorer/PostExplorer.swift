//
//  PostExplorer.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import Foundation

enum PostExplorer {
    static let Posts_Fetch_Limit = 4
    static let Stretchy_Header_Height = CGFloat(
        320
    )
    
    enum PostQueryScope: String, Hashable, Identifiable, CaseIterable {
        case Accurate, Possibilities, Price
        var id: String {
            rawValue
        }
    }
}
