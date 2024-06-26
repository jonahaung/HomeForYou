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
    static var empty: Self { .Any }
    var id: String { rawValue }
    
    case `Any`, planningAreaMap, roomCapture, mrtMap, post, appearanceSeetings, myItems, settings, myFavourites, seenPosts, myListigs,
         searchHistory, search, nearMe, rental, selling, looking
    
    var title: String { rawValue.camelCaseToWords() }
    
    var icon: SFSymbol {
        switch self {
        case .planningAreaMap:
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
        case .Any:
            return .circle
        }
    }
}
extension Service {
    var screenType: SceneKind {
        switch self {
        case .mrtMap:
            return .mrtMap({_ in })
        case .roomCapture:
            return .roomCapture
        case .planningAreaMap:
            return .planningAreaMap({_ in })
        default:
            return .eula
        }
    }
}
enum ServicesGroup: String, CaseIterable, XPickable, Identifiable, Hashable {
    static var empty: Self { .Any }
    var title: String { rawValue }
    
    var id: String { rawValue }
    
    case `Any`, tools, posting, currentUser, explorer, settings
    
    var services: [Service] {
        switch self {
        case .posting:
            return [.planningAreaMap, .roomCapture, .nearMe, .post, .settings]
        case .currentUser:
            return [.settings]
        case .tools:
            return [.mrtMap, .planningAreaMap, .roomCapture, .nearMe, .post]
        case .explorer:
            return [.roomCapture, .nearMe, .post]
        case .settings:
            return [.planningAreaMap, .roomCapture, .nearMe, .post, .settings]
        case .Any:
            return []
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
        case .Any:
            return 0
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
