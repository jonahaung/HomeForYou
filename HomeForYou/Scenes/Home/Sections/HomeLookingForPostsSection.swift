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
        InsetGroupSection(8) {
            VStack {
                ForEach(datasource.lookings) { each in
                    VStack(alignment: .leading) {
                        Text(each.title)
                            .bold()
                            .lineLimit(1)
                        ExpandableText(text: each.description)
                        if each != datasource.lookings.last {
                            Divider()
                        }
                    }
                }
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(uiColor: .secondarySystemGroupedBackground)))
        } header: {
            HomeSectionHeaderView(
                "See What People Wants",
                .person2Wave2Fill, .init(.lookingForList))
        } footer: {
            Spacer(minLength: 40)
        }
    }
}
