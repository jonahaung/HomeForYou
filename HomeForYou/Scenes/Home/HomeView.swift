//
//  HomeView.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI
import XUI

struct HomeView: View {
    
    @State private var datasource = HomeDatasource()
    @StateObject private var nearbyLocationHandler = NearbyLocationHandler()
    @StateObject private var searchViewModel = SearchDatasource()
    @Injected(\.router) private var router
    
    
    var body: some View {
        StretchyHeaderScrollView(
            namespace: "HomeView",
            headerHeight: Home.Stretchy_Header_Height,
            multipliter: 1
        ) {
            VStack {
                HomeLogoStretchSection()
                if datasource.loading {
                    LoadingIndicator()
                }
                Group {
                    HomeCategorySection()
                    HomeCarousellSection()
                    HomeNearbyPostsScetion()
                    HomeFeaturePostsSection()
                    HomeLatestPostsSection()
                    HomeBudgetPostsSection()
                    HomeLookingForPostsSection()
                }
                .background(Color.systemGroupedBackground)
            }
            .animation(
                .interactiveSpring,
                value: datasource.loading
            )
        } header: {
            lottieView
        } onRefresh: {
            await datasource.refresh()
        }
        .toolbar { HomeToolbarContent() }
        .alertPresenter($datasource.alert)
        .makeSearchable(searchViewModel)
        .background(Color.systemGroupedBackground)
        .environmentObject(searchViewModel)
        .environment(datasource)
        .environmentObject(nearbyLocationHandler)
        .onUpdateCategory {
            await datasource.refresh()
            await nearbyLocationHandler.onUpdateCategory($0)
        }
        .onSearchSubmit { item in
            switch item {
            case .areaMap:
                await router.presentFullScreen(.init(.planningAreaMap({ area in
                    let item = SceneItem(.postCollection, data: [PostFilter(.area, [area.area.rawValue])])
                    await router.push(to: item)
                })))
                
            case .mrtMap:
                await router.presentFullScreen(.init(
                    .mrtMap({ mrt in
                        let item = SceneItem(.postCollection, data: [PostFilter(.mrt, [mrt.name])])
                        await router.push(to: item)
                    })
                ))
            case .exploreAllPost:
                await router.push(to: .init(.postCollection, data: [] as [PostFilter]))
            case .filter(let filters):
                await router.push(to: .init(.postCollection, data: filters))
            case .locationPickerMap:
                await router.presentFullScreen(.init(.locationPickerMap({ locaion in
                    let item = SceneItem(.postCollection, data: [PostFilter(.keywords, [KeyWord(.postal, locaion.address.postal).keyValueString])])
                    await router.push(to: item)
                })))
            }
        }
    }
    
    // Decalared as "let" so that the view prevent from unnecessary reloading
    private let lottieView: some View = LottieView(
        lottieFile: "landscape",
        loopMode: .loop,
        contentMode: .scaleAspectFit
    ).frame(
        height: Home.Stretchy_Header_Height
    ).equatable(by: 1)
}
