//
//  PostFilter.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import Foundation

struct PostQuery: PostQueryable {
    
    let key: PostKey
    var value: String
    
    init(_ key: PostKey, _ value: String) {
        self.key = key
        self.value = value
    }
}
