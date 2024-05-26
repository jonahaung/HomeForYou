//
//  Feature.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

enum Feature: String, StringViewRepresentable {
    case Aircon, Internet, Bed, Cooking, Fridge, Sofa, TV, Study_Dask, Cleaning_Service,
         Aircon_Servicing, Hight_Floor, New_Flat, Friendly_Neighbors, Washer
    func keyword() -> KeyWord {
        .init(.features, rawValue)
    }
}
