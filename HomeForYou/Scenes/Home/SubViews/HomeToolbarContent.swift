//
//  HomeToolbar.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import XUI
import FireAuthManager

struct HomeToolbarContent: ToolbarContent {
    
    @Environment(HomeDatasource.self) private var datasource
    @Environment(CurrentUser.self) private var currentUser
    @Injected(\.router) private var router
    
    @ViewBuilder
    var body: some ToolbarContent {
        Group {
            ToolbarItemGroup(placement: .topBarTrailing) {
                SystemImage(.magnifyingglass)
                    ._presentFullScreen {
                        SearchingView()
                    }
            }
            ToolbarItemGroup(placement: .topBarLeading) {
                if !currentUser.isLoggedIn {
                    AsyncButton {
                        router.presentSheet(.init(.signIn))
                    } label: {
                        SystemImage(.personBadgeKeyFill)
                    }
                } else {
                    AsyncButton {
                        router.tab(to: .settings)
                    } label: {
                        AvatarView(urlString: currentUser.photoURL, size: 30)
                    }
                }
            }
        }
    }
}
