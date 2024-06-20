//
//  KeyWord.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/4/23.
//

import Foundation

struct KeyWord: Hashable, Identifiable, CaseIterable, RawRepresentable {
    
    var id: String { keyValueString }
    let key: PostKey
    let value: String
    
    var rawValue: String { keyValueString }
    
    init(_ key: PostKey, _ value: String) {
        self.key = key
        self.value = value
    }
    
    var keyValueString: String {
        "\(key.rawValue):\(value)"
    }
    
    var localizedString: String {
        "\(value.title) \(key.localized)"
    }
    init?(rawValue keyValueString: String) {
        let strings = keyValueString.components(separatedBy: ":")
        guard
            let keyString = strings[safe: 0],
            let key = PostKey(rawValue: keyString),
            let value = strings[safe: 1]
        else {
            return nil
        }
        self.init(key, value)
    }
    
    static let allCases: [KeyWord] = {
        var keywords = [KeyWord]()
        let mrts = MRT.allValueStrings.map { KeyWord(.mrt, $0)}
        let areas = Area.allCases.map { KeyWord(.area, $0.rawValue) }
        let features = Feature.allCases.map { KeyWord(.favourites, $0.rawValue) }
        let restrictions = Restriction.allCases.map { KeyWord(.restrictions, $0.rawValue) }
        keywords = mrts + areas + features + restrictions
        return keywords.uniqued()
    }()
}
