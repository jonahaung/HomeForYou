//
//  PostFilter.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import Foundation

struct PostQuery: Hashable, Identifiable {
    
    static func == (lhs: PostQuery, rhs: PostQuery) -> Bool {
        lhs.key == rhs.key && lhs.value == rhs.value
    }
    
    var id: String { key.rawValue }
    let key: PostKey
    var value: String
    
    init(_ key: PostKey, _ value: String) {
        self.key = key
        self.value = value
    }
    
    init?(queryItem: URLQueryItem) {
        guard
            let key = PostKey(rawValue: queryItem.name),
            let values = queryItem.value else {
            return nil
        }
        self.init(key, values)
    }
}

extension PostQuery: Comparable {
    private var sortingKey: Int {
        key.hashValue
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.sortingKey < rhs.sortingKey
    }
}
extension URLQueryItem {
    init(postQuery: PostQuery) {
        self.init(name: postQuery.key.rawValue, value: postQuery.value.description)
    }
}
