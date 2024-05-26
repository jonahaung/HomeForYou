//
//  HomeForYouApp.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import SwiftUI
import XUI

@main
struct HomeForYouApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate
    @Injected(\.store) private var store
    
    var body: some Scene {
        WindowGroup {
            AppDidLoadView(MainTabView(router: store.value.router))
                .environment(store.value.router)
                .environment(store.value.currentUser)
        }
    }
}
