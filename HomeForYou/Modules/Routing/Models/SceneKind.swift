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
    
    case signIn, developerControl, appThemeSettings, lookingForList, createPostLooking, onboarding, eula,
         mrtMap, roomCapture, createPost, postDetails, postCollection
    
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
            return PostingFlowView.typeName
        case .createPostLooking:
            return LookingForFormView.typeName
        case .postDetails:
            return PostDetailsView.typeName
        case .postCollection:
            return PostsExplorerView.typeName
        case .mrtMap:
            return MRTMap.typeName
        case .roomCapture:
            return RoomCaptureScanView.typeName
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
        case PostingFlowView.typeName:
            self = .createPost
        case LookingForFormView.typeName:
            self = .createPostLooking
        case OnboardingView.typeName:
            self = .onboarding
        case EULAView.typeName:
            self = .eula
        case PostDetailsView.typeName:
            self = .postDetails
        case MRTMap.typeName:
            self = .mrtMap
        case RoomCaptureScanView.typeName:
            self = .roomCapture
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
