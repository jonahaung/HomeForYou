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
    struct Symbol: Codable, Hashable, Identifiable {
        var id: String { code }
        let code: String
        let color: String
        var swiftColor: Color { Color(hex: color) }
    }
    
    let id: Int
    let name: String
    let type: Int
    let latitude: Double
    let longitude: Double
    let symbol: [Symbol]
    
    static let allValues: [MRT] =  {
        Bundle.main.decode([MRT].self, from: "rail_list_data.json")
    }()
    static let allValueStrings: [String] = Array(Set(allValues.map { $0.name })).sorted() + [""]
}

extension MRT {
    func mainSymbol(for mrtLine: MRTLine) -> MRT.Symbol? {
        symbol.first {
            $0.code.hasPrefix(mrtLine.code)
        }
    }
    func codeInt(for mrtLine: MRTLine) -> Int {
        guard let mainSymbol = mainSymbol(for: mrtLine) else { return 0 }
        let trimmed = mainSymbol.code.replace(mrtLine.code, with: "").trimmed
        return Int(trimmed) ?? 0
    }
}
