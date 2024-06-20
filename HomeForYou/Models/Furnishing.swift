//
//  Furnishing.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/2/23.
//

import Foundation

enum Furnishing: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`, Unfurnished, Partially_Furnished, Fully_Furnished
}
