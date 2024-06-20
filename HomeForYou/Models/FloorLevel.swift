//
//  FloorLevel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/2/23.
//

import Foundation

enum FloorLevel: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`, Basement, Ground, Low, Mid, High, Penthouse
}
