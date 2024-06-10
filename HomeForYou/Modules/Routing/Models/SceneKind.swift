//
//  ScreenType.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/2/24.
//

import SwiftUI
import XUI
import FireAuthManager
import SwiftyTheme

enum SceneKind: RawRepresentable {
    
    case signIn, developerControl, appThemeSettings, lookingForList, createPostLooking, onboarding, eula, roomCapture, createPost, postDetails, postCollection
    case mrtMap(_ onSelect: @Sendable (MRT) async -> Void)
    case planningAreaMap(_ onSelect: @Sendable (PlanningArea) async -> Void)
    case locationPickerMap(_ onSelect: @Sendable (LocationInfo) async -> Void)
    
    var rawValue: String {
        switch self {
        case .signIn:
            return AuthFlowView.typeName
        case .eula:
            return EULAView.typeName
        case .onboarding:
            return OnboardingView.typeName
        case .developerControl:
            return DeveloperControl.typeName
        case .appThemeSettings:
            return SwiftyThemeSettingsView.typeName
        case .lookingForList:
            return LookingForSceneView.typeName
        case .createPost:
            return PostingFlowView<Post>.typeName
        case .createPostLooking:
            return LookingForFormView.typeName
        case .postDetails:
            return PostDetailsView.typeName
        case .postCollection:
            return PostsExplorerView.typeName
        case .mrtMap:
            return MRTMapView.typeName
        case .roomCapture:
            return RoomCaptureScanView.typeName
        case .planningAreaMap:
            return PlanningAreaMapView.typeName
        case .locationPickerMap:
            return LocationPickerMap.typeName
        }
    }
    init?(rawValue: String) {
        switch rawValue {
        case AuthFlowView.typeName:
            self = .signIn
        case PostsExplorerView.typeName:
            self = .postCollection
        case DeveloperControl.typeName:
            self = .developerControl
        case SwiftyThemeSettingsView.typeName:
            self = .appThemeSettings
        case LookingForSceneView.typeName:
            self = .lookingForList
        case PostingFlowView<Post>.typeName:
            self = .createPost
        case LookingForFormView.typeName:
            self = .createPostLooking
        case OnboardingView.typeName:
            self = .onboarding
        case EULAView.typeName:
            self = .eula
        case PostDetailsView.typeName:
            self = .postDetails
        case MRTMapView.typeName:
            self = .mrtMap{ _ in}
        case RoomCaptureScanView.typeName:
            self = .roomCapture
        case PlanningAreaMapView.typeName:
            self = .planningAreaMap{ _ in}
        case LocationPickerMap.typeName:
            self = .locationPickerMap{ _ in}
        default:
            return nil
        }
    }
    init?(url: URL) {
        guard
            let components = URLComponents(string: url.absoluteString),
            let screenTypeRaw = components.host
        else {
            return nil
        }
        self.init(rawValue: screenTypeRaw)
    }
    var id: String { rawValue }
}

extension SceneKind {
    
}

extension OnboardingItem {
    static let preview: [OnboardingItem] = {
        let images = ["bg_beach", "bg_gardening", "bg_guitar", "bg_home", "bg_lawning", "bg_mountain", "bg_skyDiving"]
        return images.map { OnboardingItem(title: Lorem.title, subtitle: Lorem.paragraph, imageName: $0)}
    }()
}
