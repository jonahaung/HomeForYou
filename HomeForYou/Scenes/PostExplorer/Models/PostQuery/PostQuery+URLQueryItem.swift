//
//  PostQuery+URLQueryItem.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 13/6/24.
//

import Foundation

extension URLQueryItem {
    init(postQuery: PostQuery) {
        self.init(name: postQuery.key.rawValue, value: postQuery.value)
    }
}
