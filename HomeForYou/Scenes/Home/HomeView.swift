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
    }
    
    // Decalared as "let" so that the view prevent from unnecessary reloading
    private let lottieView: some View = LottieView(
        lottieFile: "landscape",
        loopMode: .loop,
        contentMode: .scaleAspectFit
    ).frame(
        height: Home.Stretchy_Header_Height
    )
}
