//
//  MRTSearchingWorker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/6/24.
//

import Foundation

struct MRTSearchingWorker {

    func search(text: String) -> [String] {
        let smartSearcher = SmartSearchMatcher(searchString: text)
        var results = [String]()
        for keyword in MRT.allValueStrings where smartSearcher.matches(keyword.replace("_", with: " ").lowercased()) {
            results.append(keyword)
        }
        return results
    }
}
