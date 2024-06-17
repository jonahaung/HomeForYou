//
//  CustomTabBarView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import SwiftUI
import XUI
import SwiftyTheme

struct MainTabView: View {
    
    @State var router: Router
    private let magicButtonViewModel = MagicButtonViewModel()
    @Injected(\.utils) private var utils: Utils
    @State private var developerText = ""
    var body: some View {
        TabView(selection: $router.tabPath) {
            ForEach(router.navRouters) { navRouter in
                MainNavView(navRouter) {
                    switch navRouter.tab {
                    case .myItems:
                        MyItemsView()
                            .navigationTitle(L10n_.Navigation.Title.my_stuffs)
                            .magicButton(homeMagicItem)
                    case .createPost:
                        PostingMenuView()
                            .navigationTitle(L10n_.Navigation.Title.post)
                            .magicButton(homeMagicItem)
                    case .home:
                        HomeView()
                            .navigationTitle(L10n_.Navigation.Title.home)
                            .magicButton(.explorer)
                    case .more:
                        ServicesView()
                            .navigationTitle(L10n_.Navigation.Title.services)
                            .magicButton(homeMagicItem)
                    case .settings:
                        SettingsView()
                            .navigationTitle(L10n_.Navigation.Title.settings)
                            .magicButton(homeMagicItem)
                    }
                }
                .tabItem {
                    if navRouter.tab != .home {
                        Label(navRouter.tab.rawValue, systemSymbol: navRouter.tab.symbol)
                    }
                }
                .tag(navRouter.tab)
            }
        }
        .sheet(item: .init(get: {
            router.sheets.last
        }, set: { _ in
            if !router.sheets.isEmpty {
                router.sheets.removeLast()
            }
        })) {
            $0.viewToDisplay
                .swiftyThemeStyle()
        }
        .fullScreenCover(item: .init(get: {
            router.fullScreenCovers.last
        }, set: { newValue in
            if !router.fullScreenCovers.isEmpty {
                router.fullScreenCovers.removeLast()
            } 
        })) {
            $0.viewToDisplay
                .swiftyThemeStyle()
        }
        .overlay(alignment: magicButtonViewModel.item.alignment) {
            MagicButton()
        }
        .environment(magicButtonViewModel)
        .onOpenURL { url in
            Task {
                do {
                    let path = try await utils.urlHandler.parse(for: url)
                    router.push(to: path)
                } catch {
                    Log(error)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var homeMagicItem: MagicButtonItem {
        .init(.houseCircleFill, .bottom) {
            router.tab(to: .home)
        }
    }
}
