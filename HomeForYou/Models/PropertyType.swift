//
//  PropertyType.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

enum PropertyType: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`, HDB, Condo, Landed, Other
}
