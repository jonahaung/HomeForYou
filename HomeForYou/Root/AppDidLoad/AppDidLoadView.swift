//
//  SetupableView.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI
import XUI
import L10n_swift
import SwiftyTheme

struct AppDidLoadView<Content: View>: View {
    
    @Injected(\.router) private var router
    @State private var appReloader = AppReloader()
    private let appConfigs = AppConfigs()
    
    private let content: () -> Content
    init(_ content: @escaping @autoclosure () -> Content) {
        self.content = content
    }
    
    var body: some View {
        if appReloader.showSplashScreen {
            SplashScreenView()
                .swiftyThemeStyle()
                ._onAppear(after: 0.4) {
                    appReloader.showSplashScreen = false
                }
        } else {
            content()
                .environment(appConfigs)
                .environment(appReloader)
                .swiftyThemeStyle()
                .onAppear {
                    router.checkSetupStatus()
                }
        }
    }
}
