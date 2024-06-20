//
//  Feature.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation
import XUI
import SFSafeSymbols

enum Feature: String, StringViewRepresentable {
    static var empty: Feature { .Any }
    
    case `Any`, Aircon, Internet, Cooking, Fridge, Sofa, TV, Study_Dask, Cleaning_Service,
         Aircon_Servicing, Hight_Floor, New_Flat, Friendly_Neighbors, Washer
    func keyword() -> KeyWord {
        .init(.features, rawValue)
    }
    var symbol: SFSymbol {
        switch self {
        case .Aircon:
            return .airConditionerHorizontalFill
        case .Internet:
            return .wifi
        case .Cooking:
            return .fryingPanFill
        case .Fridge:
            return .refrigeratorFill
        case .Sofa:
            return .chairLoungeFill
        case .TV:
            return .playTvFill
        case .Study_Dask:
            return .tableFurnitureFill
        case .Cleaning_Service:
            return .trashSlashSquare
        case .Aircon_Servicing:
            return .airConditionerVerticalFill
        case .Hight_Floor:
            return .buildingFill
        case .New_Flat:
            return .buildingFill
        case .Friendly_Neighbors:
            return .balloonFill
        case .Washer:
            return .washerFill
        case .Any:
            return .circle
        }
    }
}
