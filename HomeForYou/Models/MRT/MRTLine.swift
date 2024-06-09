//
//  MRTLine.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/24.
//

import SwiftUI
enum MRTLine: String, Codable, Identifiable, CaseIterable, Hashable {
    
    var id: String { rawValue }
    case yellow = "#FFA500"
    case red = "#ff0000"
    case blue = "#0067B2"
    case green = "#00aa00"
    case purple = "#8B008B"
    case brown = "#9D5B25"
    
    var color: Color { Color(hex: rawValue.replace("#", with: "")) }
    
    var name: String {
        switch self {
        case .yellow:
            return "Circle"
        case .red:
            return "North-Sourth"
        case .blue:
            return "Downtown"
        case .green:
            return "East-West"
        case .purple:
            return "North-East"
        case .brown:
            return "Thomson-East Coast"
        }
    }
    
    var mrts: [MRT] {
        return MRT.allValues.filter({ mrt in
            mrt.symbol.contains { item in
                item.color == self.rawValue
            }
        }).removeDuplicates(by: { one, two in
            one.name == two.name
        }).sorted { lhs, rhs in
            lhs.mainSymbol(for: self.rawValue).code.parseToInt() > rhs.mainSymbol(for: self.rawValue).code.parseToInt()
        }
    }
}

extension String {
    func parseToInt() -> Int {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
    }
}
