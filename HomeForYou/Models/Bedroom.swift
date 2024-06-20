//
//  Beds.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/2/23.
// l

import Foundation

enum Bedroom: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`, Studio, One, Two, Three, Four
    case Five_Plus = "5+"

}
