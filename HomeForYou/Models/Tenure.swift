//
//  Term.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 20/1/23.
//

import Foundation

enum Tenure: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`
    case Freehold
    case ninty_nine = "99-year Leasehold"
    case one_o_three = "103-year Leasehold"
    case nine_nine_nine = "999-year Leasehold"
    case Unknown_Tenure
}
