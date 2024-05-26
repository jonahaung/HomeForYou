//
//  Service.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/2/24.
//

import Foundation
import XUI
import SFSafeSymbols
import SwiftUI

enum Service: String, CaseIterable, XPickable {
    var id: String { rawValue }
    
    case addressFinder, roomCapture, mrtMap, post, appearanceSeetings, myItems, settings, myFavourites, seenPosts, myListigs,
         searchHistory, search, nearMe, rental, selling, looking
    
    var title: String { rawValue.camelCaseToWords() }
    
    var icon: SFSymbol {
        switch self {
        case .addressFinder:
            return .mapFill
        case .roomCapture:
            return .cameraMeteringMatrix
        case .mrtMap:
            return .trainSideFrontCar
        case .post:
            return .pencilAndOutline
        case .appearanceSeetings:
            return .paintpaletteFill
        case .myItems:
            return .sharedWithYou
        case .settings:
            return .gearshapeFill
        case .myFavourites:
            return .heartFill
        case .seenPosts:
            return .clockBadgeFill
        case .myListigs:
            return .personTextRectangleFill
        case .searchHistory:
            return .aMagnify
        case .search:
            return .waveformAndMagnifyingglass
        case .nearMe:
            return .mappinAndEllipse
        case .rental:
            return .houseFill
        case .selling:
            return .signature
        case .looking:
            return .facemaskFill
        }
    }
}
extension Service {
    var screenType: SceneKind {
        switch self {
        case .mrtMap:
            return .mrtMap
        case .roomCapture:
            return .roomCapture
        default:
            return .eula
        }
    }
}
enum ServicesGroup: String, CaseIterable, XPickable, Identifiable, Hashable {
    var title: String { rawValue }
    
    var id: String { rawValue }
    
    case tools, posting, currentUser, explorer, settings
    
    var services: [Service] {
        switch self {
        case .posting:
            return [.addressFinder, .roomCapture, .nearMe, .post, .settings]
        case .currentUser:
            return [.settings]
        case .tools:
            return [.mrtMap, .addressFinder, .roomCapture, .nearMe, .post]
        case .explorer:
            return [.roomCapture, .nearMe, .post]
        case .settings:
            return [.addressFinder, .roomCapture, .nearMe, .post, .settings]
        }
    }
    var tag: Int {
        switch self {
        case .tools:
            return 1
        case .posting:
            return 2
        case .currentUser:
            return 3
        case .explorer:
            return 4
        case .settings:
            return 5
        }
    }
}
extension String {
    func camelCaseToWords() -> String {
        self
            .replacingOccurrences(
                of: "([A-Z])",
                with: " $1",
                options: .regularExpression,
                range: range(of: self)
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
}
