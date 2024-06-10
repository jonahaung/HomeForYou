//
//  MRTLine.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/24.
//

import SwiftUI
enum MRTLine: String, Codable, Identifiable, CaseIterable, Hashable {
    
    var id: String { rawValue }
    case CC, NS, DT, EW, NE, TE
    
    var code: String { rawValue }
    var hashColor: String {
        switch self {
        case .CC:
            return "#FFA500"
        case .NS:
            return "#ff0000"
        case .DT:
            return "#0067B2"
        case .EW:
            return "#00aa00"
        case .NE:
            return "#8B008B"
        case .TE:
            return "#9D5B25"
        }
    }
    var color: Color { Color(hex: hashColor) }
    
    var name: String {
        switch self {
        case .CC:
            return "Circle Line"
        case .NS:
            return "North-Sourth Line"
        case .DT:
            return "Downtown Line"
        case .EW:
            return "East-West Line"
        case .NE:
            return "North-East Line"
        case .TE:
            return "Thomson-East Coast Line"
        }
    }
    
    var mrts: [MRT] {
        let items = MRT.allValues.filter({ mrt in
            mrt.mainSymbol(for: self) != nil
        })
        return items.removeDuplicates { lhs, rhs in
            lhs.name == rhs.name
        }.sorted { lhs, rhs in
            lhs.codeInt(for: self) < rhs.codeInt(for: self)
        }
    }
}

extension String {
    func parseToInt() -> Int {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
    }
}
