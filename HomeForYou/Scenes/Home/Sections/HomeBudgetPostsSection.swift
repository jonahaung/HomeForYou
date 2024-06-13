//
//  HomeBudgetPostsSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import XUI

struct HomeBudgetPostsSection: View {
    
    @Environment(HomeDatasource.self) private var datasource
    
    var body: some View {
        InsetGroupSection(4) {
            WaterfallVList(columns: 2, spacing: 3) {
                ForEach(datasource.budgetPosts) { each in
                    PostDoubleColumnCell()
                        .environmentObject(each)
                    
                }
            }
        } header: {
            HomeSectionHeaderView(
                "Budget Listings",
                .dollarsignArrowCirclepath,
                [.init(.price, "\(0)-\(100000000000)")]
            )
        }
        .equatable(by: datasource.budgetPosts)
    }
}
