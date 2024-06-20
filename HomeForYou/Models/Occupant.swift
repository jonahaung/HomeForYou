//
//  Cccupant.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/6/23.
//

import SwiftUI
import XUI
enum Occupant: String, StringViewRepresentable, XPickable {
    static var empty: Self { .Any }
    case single_male = "Single Male"
    case single_female = "Single Female"
    case two_female = "Two Female"
    case two_male = "Two Male"
    case couple = "Couple"
    case multiple_tenant = "Multiple Tenant"
    case `Any`
}
