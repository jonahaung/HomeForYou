//
//  SearchingWorker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/8/23.
//

import Foundation
import XUI

struct KeywordsSearchingWorker {

    func search(text: String) -> [KeyWord] {
        let smartSearcher = SmartSearchMatcher(searchString: text)
        var keywords = [KeyWord]()
        for keyword in KeyWord.all where smartSearcher.matches(keyword.value.replace("_", with: " ").lowercased()) {
            keywords.append(keyword)
        }
        return keywords
    }
}
