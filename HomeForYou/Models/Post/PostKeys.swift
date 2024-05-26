//
//  PostKeys.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/5/23.
//

import Foundation
import XUI
import SFSafeSymbols

enum PostKeys: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }

    case category
    case id
    case autherID
    case author
    case attachments
    case title
    case description
    case phoneNumber
    case price
    case occupant
    case area
    case mrt
    case mrtDistance
    case address
    case postal
    case location
    case locationInfo
    case propertyType
    case roomType
    case furnishing
    case beds
    case baths
    case floorLevel
    case tenantType
    case leaseTerm
    case tenure
    case availableDate
    case features
    case restrictions
    case status
    case createdAt
    case keywords
    case views
    case favourites
    case additional
    case geoHash

    static let keywordKeys = [PostKeys.area, .mrt, .features, restrictions]

    var localized: String {
        switch self {
        case .category:
            return "Category"
        case .id:
            return "ID"
        case .autherID:
            return "Author"
        case .phoneNumber:
            return "Ph"
        case .price:
            return "$"
        case .occupant:
            return "Occupant"
        case .area:
            return "Area"
        case .mrt:
            return "MRT"
        case .mrtDistance:
            return "s"
        case .address:
            return "Address"
        case .postal:
            return "Postal"
        case .location:
            return "long/lat"
        case .roomType:
            return "Room"
        case .furnishing:
            return "Furnished"
        case .beds:
            return "Bed(s)"
        case .baths:
            return "Bath(s)"
        case .floorLevel:
            return "Floor"
        case .tenantType:
            return "Tenant"
        case .leaseTerm:
            return "Lease"
        case .tenure:
            return "Tenure"
        case .availableDate:
            return "Onwards"
        case .features:
            return "(dos)"
        case .restrictions:
            return "(don't)"
        case .views:
            return "Views"
        case .favourites:
            return "Likes"
        case .geoHash:
            return "#"
        default:
            return ""
        }
    }
    
    var symbol: SFSymbol {
        switch self {
        case .category:
            return .lizard
        case .id:
            return .personCircleFill
        case .autherID:
            return .personCropSquareFill
        case .author:
            return .personCropArtframe
        case .attachments:
            return .atCircleFill
        case .title:
            return .textAppend
        case .description:
            return .textformat
        case .phoneNumber:
            return .phoneFill
        case .price:
            return .dollarsign
        case .occupant:
            return .person3SequenceFill
        case .area:
            return .locationFill
        case .mrt:
            return .tramFill
        case .mrtDistance:
            return .mappin
        case .address:
            return .at
        case .postal:
            return .envelopeFill
        case .location:
            return .locationCircleFill
        case .locationInfo:
            return .locationFill
        case .propertyType:
            return .building2CropCircleFill
        case .roomType:
            return .windowShadeOpen
        case .furnishing:
            return .sofaFill
        case .beds:
            return .bedDoubleCircleFill
        case .baths:
            return .showerFill
        case .floorLevel:
            return .stairs
        case .tenantType:
            return .plusminusCircleFill
        case .leaseTerm:
            return .calendar
        case .tenure:
            return .calendarBadgeClock
        case .availableDate:
            return .clockFill
        case .features:
            return .checkmarkCircleFill
        case .restrictions:
            return .xmarkCircleFill
        case .status:
            return .waveform
        case .createdAt:
            return .pencilCircleFill
        case .keywords:
            return .listDash
        case .views:
            return .eyeCircleFill
        case .favourites:
            return .starFill
        case .additional:
            return ._00Circle
        case .geoHash:
            return .mappinSlashCircleFill
        }
    }
}
