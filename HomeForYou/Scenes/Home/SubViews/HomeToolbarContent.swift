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
    
    @Environment(CurrentUser.self) private var currentUser
    @EnvironmentObject private var searchViewModel: SearchDatasource
    @Injected(\.router) private var router
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            AsyncButton {
                searchViewModel.isPresented = true
            } label: {
                SystemImage(.magnifyingglass)
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
