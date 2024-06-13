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
    static func set(items: [String]) {
        self.items = items
    }
    static var responses: [Search.Result] {
        keywords.map{ Search.Result(attributedString: .init($0.value.title, attributes: .init([.font: UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium), .foregroundColor: UIColor.label, .paragraphStyle: NSMutableParagraphStyle.wordWrappingLineBreak])), keyword: $0) }
    }
    static var keywords: [KeyWord] {
        items.compactMap { KeyWord(rawValue: $0) }
    }
}
