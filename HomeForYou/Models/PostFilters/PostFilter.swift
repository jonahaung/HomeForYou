//
//  PostFilter.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import Foundation

struct PostFilter: Hashable, Identifiable, Codable {
    var id: String { postKey.rawValue }

    let postKey: PostKeys
    let values: [String]
    
    init(_ postKey: PostKeys, _ values: [String]) {
        self.postKey = postKey
        self.values = values
    }
    
    init?(queryItem: URLQueryItem) {
        guard let postKey = PostKeys(rawValue: queryItem.name),
              let values = queryItem.value?.components(separatedBy: ",") else {
            return nil
        }
        self.init(postKey, values)
    }
}
extension PostFilter: Comparable {
    private var priority: Int {
        postKey.hashValue
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority < rhs.priority
    }
}
extension URLQueryItem {
    
    init(postFilter: PostFilter) {
        self.init(name: postFilter.postKey.rawValue, value: postFilter.values.joined(separator: ","))
    }
}
