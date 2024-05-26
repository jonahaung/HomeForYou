//
//  HomeLatestPostsSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import XUI

struct HomeLatestPostsSection: View {
    
    @Environment(HomeDatasource.self) private var datasource
    
    var body: some View {
        InsetGroupSection {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 0) {
                ForEach(datasource.latestPosts) { each in
                    PostDoubleColumnCell()
                        .environmentObject(each)
                }
            }
        } header: {
            HomeSectionHeaderView("Latest Listings", .clockFill, [])
        }
        .equatable(by: datasource.latestPosts)
    }
}
