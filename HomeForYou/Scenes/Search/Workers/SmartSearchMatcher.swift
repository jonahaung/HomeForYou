//
//  SmartSearchMatcher.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/8/23.
//

import Foundation

struct SmartSearchMatcher {
    
    public init(searchString: String) {
        searchTokens = searchString.split(whereSeparator: { $0.isWhitespace }).sorted { $0.count > $1.count }
    }
    func matches(_ candidateString: String) -> Bool {
        guard !searchTokens.isEmpty else { return true }
        var candidateStringTokens = candidateString.split(whereSeparator: { $0.isWhitespace })
        for searchToken in searchTokens {
            var matchedSearchToken = false
            for (candidateStringTokenIndex, candidateStringToken) in candidateStringTokens.enumerated() {
                if let range = candidateStringToken.range(of: searchToken, options: [.caseInsensitive, .diacriticInsensitive]),
                   range.lowerBound == candidateStringToken.startIndex {
                    matchedSearchToken = true
                    candidateStringTokens.remove(at: candidateStringTokenIndex)
                    break
                }
            }
            guard matchedSearchToken else { return false }
        }
        return true
    }
    
    private(set) var searchTokens: [String.SubSequence]
}

private extension String {
    func distance(from key: String) -> Int {
        String.levenshteinDist(test: self, key: key)
    }
    static func levenshteinDist(test: String, key: String) -> Int {
        let empty = [Int](repeating: 0, count: key.count)
        var last = [Int](0...key.count)
        for (i, testLetter) in test.enumerated() {
            var cur = [i + 1] + empty
            for (j, keyLetter) in key.enumerated() {
                cur[j + 1] = testLetter == keyLetter ? last[j] : Swift.min(last[j], last[j + 1], cur[j]) + 1
            }
            last = cur
        }
        return last.last!
    }
}
