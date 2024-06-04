//
//  AttributedStringMaker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/8/23.
//

import SwiftUI

struct SearchResultsFactoryWorker {
    func create(searchResults: [String], searchText: String) -> [AttributedString] {
        var results = [AttributedString]()
        searchResults.forEach { searchResult in
            let attributedString: AttributedString = {
                var text = AttributedString(searchResult.title, attributes: .init([.paragraphStyle: NSMutableParagraphStyle.wordWrappingLineBreak, .font : UIFont.systemFont(ofSize: UIFont.labelFontSize), .foregroundColor: UIColor.secondaryLabel]))
                searchText.words().forEach { each in
                    if let range = text.range(of: each.trimmed.capitalized) {
                        text[range].font = .systemFont(ofSize: UIFont.buttonFontSize + 2, weight: .medium)
                        text[range].foregroundColor = .primary
                    }
                }
                return text
            }()
            results.append(attributedString)
        }
        return results.uniqued()
    }
}

extension NSMutableParagraphStyle {
    
    static let wordWrappingLineBreak: NSMutableParagraphStyle = {
        $0.lineBreakMode = .byWordWrapping
        $0.alignment = .left
        $0.lineSpacing = 0
        $0.lineHeightMultiple = 0
        return $0
    }(NSMutableParagraphStyle())
}
