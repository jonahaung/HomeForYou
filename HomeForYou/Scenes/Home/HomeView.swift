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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 22) {
                HomeLogoSection()
                HomeCategorySection()
                HomeCarousellSection()
                HomeNearbyPostsScetion()
                HomeFeaturePostsSection()
                HomeLatestPostsSection()
                HomeBudgetPostsSection()
                HomeLookingForPostsSection()
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .showLoading(datasource.loading)
        .toolbar { HomeToolbarContent() }
        .alertPresenter($datasource.alert)
        .refreshable {
            await nearbyLocationHandler.refresh(.current)
            await datasource.performFetch(category: Category.current)
        }
        .onUpdateCategory {
            Log($0)
            await nearbyLocationHandler.refresh($0)
            await datasource.performFetch(category: $0)
        }
        .environment(datasource)
        .environmentObject(nearbyLocationHandler)
    }
}
