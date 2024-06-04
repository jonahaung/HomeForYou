//
//  HomeLookingForPostsSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import XUI

struct HomeLookingForPostsSection: View {
    
    @Environment(HomeDatasource.self) private var datasource
    
    var body: some View {
        InsetGroupSection(0) {
            InsetGroupList {
                ForEach(datasource.lookings) { each in
                    VStack(alignment: .leading) {
                        Text(each.title)
                            .font(.headline)
                        ExpandableText(text: each.description)
                            .font(.callout)
                    }
                }
            }
        } header: {
            HomeSectionHeaderView(
                "See What People Wants",
                .person2Wave2Fill, .init(.lookingForList))
        } footer: {
            Spacer(minLength: 40)
        }
    }
}
