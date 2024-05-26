//
//  MRT.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation
import SwiftUI
import XUI

struct MRT: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let type: Int
    let latitude: Double
    let longitude: Double
    let symbol: [Symbol]
    
    struct Symbol: Codable, Hashable, Identifiable {
        var id: String { code + color }
        let code: String
        let color: String
        var swiftColor: Color? {
            Color(hex: color)
        }
    }
    func mainSymbol(for color: String) -> Symbol {
        symbol.first { x in
            x.color == color
        } ?? .init(code: "", color: "")
    }
    static let allValues: [MRT] = Bundle.main.decode([MRT].self, from: "rail_list_data.json").removeDuplicates { lhs, rhs in
        lhs.name == rhs.name && lhs.symbol == rhs.symbol
    }
    static let allValueStrings: [String] = Array(Set(allValues.map { $0.name })).sorted() + [""]
}
