//
//  TenantType.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import Foundation

enum TenantType: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`, Male, Female, Couple, Family, No_Preferences
}
