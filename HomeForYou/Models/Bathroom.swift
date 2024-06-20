//
//  Baths.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/2/23.
//

import Foundation

enum Bathroom: String, StringViewRepresentable {
    static var empty: Bathroom { .Any }
    case `Any`, One, Two, Three, Four
    case Five_Plus = "5+"
}
