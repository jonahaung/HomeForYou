//
//  PostQueryable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 13/6/24.
//

import Foundation

protocol PostQueryable: Codable, Hashable, Sendable, Identifiable, Comparable {
    var key: PostKey { get }
    var value: String { get }
    init(_ key: PostKey, _ value: String)
}
extension PostQueryable {
    var id: String { key.rawValue + value }
}
extension PostQueryable {
    private var sortingKey: Int {
        key.hashValue
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.sortingKey < rhs.sortingKey
    }
}
extension PostQueryable {
    init?(queryItem: URLQueryItem) {
        guard
            let key = PostKey(rawValue: queryItem.name),
            let values = queryItem.value else {
            return nil
        }
        self.init(key, values)
    }
}
