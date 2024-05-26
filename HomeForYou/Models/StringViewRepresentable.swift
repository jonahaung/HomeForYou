//
//  StringViewRepresentable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import Foundation
import XUI

protocol StringViewRepresentable: RawRepresentable, Codable, Identifiable, CaseIterable, XPickable {
    var id: RawValue { get }
}

extension StringViewRepresentable {
    var id: String { "\(rawValue)" }
    var title: String {
        if id == "Any" { return "" }
        return id.components(separatedBy: "_").joined(separator: " ")
    }

    var typeName: String { "\(type(of: self))" }

    static var allCasesExpectEmpty: [Self] { Self.allCases.filter { $0.id != "Any" } }
}
