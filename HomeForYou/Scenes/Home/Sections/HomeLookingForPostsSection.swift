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
    @State private var selection: Looking?
    
    var body: some View {
        ScrollViewList {
            subviews.intersperse {
                Divider()
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder private var subviews: some View {
        ForEach(datasource.lookings) { each in
            VStack(alignment: .leading) {
                Text(each.title)
                    .font(.headline)
                ExpandableText(text: each.description)
            }
        }
    }
}
