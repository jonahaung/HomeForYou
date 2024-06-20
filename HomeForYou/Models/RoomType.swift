//
//  RoomType.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

enum RoomType: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`, Common, Master, Shared, Utilities, Studio, Other
}
