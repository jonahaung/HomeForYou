//
//  Restriction.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

enum Restriction: String, StringViewRepresentable {
    case Light_Cooking, No_Cooking, No_Smoking, No_Drinking, No_Visitors, No_Night_Visitors, No_Pork, No_Night_Shift
    func keyword() -> KeyWord {
        .init(.restrictions, rawValue)
    }
}
