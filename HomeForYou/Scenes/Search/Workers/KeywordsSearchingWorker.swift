//
//  SearchingWorker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/8/23.
//

import Foundation
import XUI

struct KeywordsSearchingWorker {

    func search(text: String) -> [String] {
        let smartSearcher = SmartSearchMatcher(searchString: text)
        var results = [String]()
        for keyword in (KeyWord.all.map{ $0.value }) where smartSearcher.matches(keyword.replace("_", with: " ").lowercased()) {
            results.append(keyword)
        }
        return results
    }
}
