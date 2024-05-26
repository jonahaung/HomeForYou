//
//  HomeFeaturePostsSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import XUI

struct HomeFeaturePostsSection: View {
    
    @Environment(HomeDatasource.self) private var datasource
    
    var body: some View {
        InsetGroupSection {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(datasource.featurePosts) { each in
                        PostHCell()
                            .environmentObject(each)
                    }
                }
            }
            .frame(height: 170)
        } header: {
            HomeSectionHeaderView(
                "Feature Listings",
                .sparkles,
                []
            )
        }
        .equatable(by: datasource.featurePosts)
    }
}
