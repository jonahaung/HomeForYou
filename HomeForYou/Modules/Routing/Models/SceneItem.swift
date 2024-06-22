//
//  FullScreenCover.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import SwiftUI
import XUI
import SwiftyTheme
import FireAuthManager

struct SceneItem: ViewDisplayable {
    let kind: SceneKind
    let data: AnyHashable?
    
    init(_ kind: SceneKind, data: AnyHashable? = nil) {
        self.kind = kind
        self.data = data
    }
    var id: String { kind.rawValue + (data?.hashValue.description ?? "") }
    
    static func == (lhs: SceneItem, rhs: SceneItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension SceneItem {
    @ViewBuilder
    var viewToDisplay: some View {
        switch kind {
        case .signIn:
            @Injected(\.currentUser) var currentUser
            AuthFlowView(currentUser: currentUser)
        case .developerControl:
            DeveloperControl()
        case .appThemeSettings:
            SwiftyThemeSettingsView()
        case .lookingForList:
            LookingForSceneView()
        case .createPost:
            if let post = data as? Post {
                PostingFlowView(post: post)
            }
        case .createPostLooking:
            LookingForFormView(.current)
        case .onboarding:
            OnboardingView(items: OnboardingItem.preview)
        case .eula:
            EULAView(text: Lorem.paragraphs(9))
        case .postDetails:
            if let post = data as? Post {
                PostDetailsView()
                    .environmentObject(post)
            }
        case .postCollection:
            let query = data as? CompoundQuery ?? .init(.accurate, [])
            PostsExplorerView(query: query)
        case .mrtMap(let onSelect):
            MRTMapView(onSelect: onSelect)
        case .roomCapture:
            RoomCaptureScanView()
        case .planningAreaMap(let onSelect):
            PlanningAreaMapView(onSelect: onSelect)
        case .locationPickerMap(let onSelect):
            LocationPickerMap(onSelect: onSelect)
        }
    }
}
