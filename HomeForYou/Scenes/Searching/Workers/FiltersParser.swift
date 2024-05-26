//
//  KeywordsParser.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/8/23.
//

import Foundation

struct FiltersParser {

    func parse(_ text: String) async -> [PostFilter] {
        var filters = [PostFilter]()
        if let keyword = KeyWord(keyValueString: text.trimmed) {
            switch keyword.key {
            case .mrt:
                filters.append(.init(.mrt, [keyword.value]))
            case .area:
                filters.append(.init(.area, [keyword.value]))
            case .features:
                if let x = Feature(rawValue: keyword.value) {
                    filters.append(.init(.features, [x.rawValue]))
                }
            case.restrictions:
                if let x = Restriction(rawValue: keyword.value) {
                    filters.append(.init(.restrictions, [x.rawValue]))
                }
            default:
                break
            }
        }

        guard filters.isEmpty else {
            return filters
        }
        do {
            let info = try await GeoCoder.createLocationInfo(from: text)
            filters.append(.init(.area, [info.area.rawValue]))
            filters.append(.init(.mrt, [info.nearestMRT.mrt]))
            filters.append(.init(.geoHash, [info.geoInfo.geoHash]))
            filters.append(.init(.postal, [info.address.postal]))
        } catch {
            KeyWord.all.forEach { each in
                if PostKeys.keywordKeys.contains(each.key) {
                    if text.lowercased().trimmed.contains(each.value.title.lowercased()) {
                        switch each.key {
                        case .mrt:
                            filters.append(.init(.mrt, [each.value]))
                        case .area:
                            if let area = Area(string: each.value) {
                                filters.append(.init(.area, [area.rawValue]))
                            }
                        case .features:
                            if let x = Feature(rawValue: each.value) {
                                filters.append(.init(.features, [x.rawValue]))
                            }
                        case.restrictions:
                            if let x = Restriction(rawValue: each.value) {
                                filters.append(.init(.restrictions, [x.rawValue]))
                            }
                        default:
                            break
                        }
                    }
                }
            }
        }

        return filters
    }
}
