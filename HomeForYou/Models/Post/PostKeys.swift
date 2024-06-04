//
//  PostKeys.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/5/23.
//

import Foundation
import XUI
import SFSafeSymbols

enum PostKeys: String, Codable, CaseIterable, Identifiable, Hashable {
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
            return rawValue.capitalized
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
            return "(features)"
        case .restrictions:
            return "(restrictions)"
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
            return .locationFillViewfinder
        case .mrt:
            return .tram
        case .mrtDistance:
            return .ruler
        case .address:
            return .houseCircle
        case .postal:
            return .envelopeCircleFill
        case .location:
            return .mappinAndEllipse
        case .locationInfo:
            return .mappinAndEllipse
        case .propertyType:
            return .building
        case .roomType:
            return .doorFrenchOpen
        case .furnishing:
            return .sofa
        case .beds:
            return .bedDoubleFill
        case .baths:
            return .showerFill
        case .floorLevel:
            return .figureStairs
        case .tenantType:
            return .person2
        case .leaseTerm:
            return .handRaisedFingersSpreadFill
        case .tenure:
            return .calendarBadgeClock
        case .availableDate:
            return .calendarCircleFill
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
            return .atBadgeMinus
        }
    }
}
