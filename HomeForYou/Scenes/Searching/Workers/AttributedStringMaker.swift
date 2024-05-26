//
//  AttributedStringMaker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/8/23.
//

import SwiftUI

struct SearchResultsFactoryWorker {
    func create(keywords: [KeyWord], searchText: String) -> [Searching.Response] {
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = .byWordWrapping
        para.alignment = .left
        var results = [Searching.Response]()
        keywords.forEach { keyword in
            let attributedString: AttributedString = {
                var text = AttributedString(keyword.value.title, attributes: .init([.paragraphStyle: para]))
                text.foregroundColor = .secondary
                text.font = .systemFont(ofSize: UIFont.labelFontSize)
                if let range = text.range(of: searchText.capitalized) {
                    text[range].font = .systemFont(ofSize: UIFont.labelFontSize, weight: .semibold)
                    text[range].foregroundColor = .primary
                }
                return text
            }()
            results.append(.init(attributedString: attributedString, keyword: keyword))
        }
        return results.uniqued()
    }
}
