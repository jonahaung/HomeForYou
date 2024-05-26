//
//  SearchStorage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/8/23.
//

import UIKit

struct SearchStorage {
    static var items: [String] {
        get {
            UserDefaults.standard.array(forKey: "SearchStorage") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SearchStorage")
        }
    }

    static func insert(text: String) {
        if let i = items.firstIndex(of: text) {
            items.remove(at: i)
        }
        items.insert(text, at: 0)
        items = Array(items.prefix(20))
    }

    static var responses: [Searching.Response] {
        items.compactMap {
            if let keyword = KeyWord(keyValueString: $0) {
                return Searching.Response(attributedString: .init(keyword.value.title, attributes: .init([.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)])), keyword: keyword)
            }
            return nil
        }
    }
}
