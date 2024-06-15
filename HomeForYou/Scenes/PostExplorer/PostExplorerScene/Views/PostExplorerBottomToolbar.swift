//
//  PostExplorerToolBar.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/6/24.
//

import SwiftUI
import XUI

struct PostExplorerBottomToolbar: View {
    
    @EnvironmentObject private var viewModel: PostExplorerViewModel
    @EnvironmentObject private var searchDatasource: SearchDatasource
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var storage: PostQueryStorage
    
    var body: some View {
        VStack {
            if editMode?.wrappedValue == .active {
                PostExplorerGridStylePicker()
                    .transition(.move(edge: .bottom).combined(with: .blurReplace))
            }
            HStack {
                SystemImage(.map)
                    ._presentSheet {
                        LocationMap(viewModel.displayDatas.map{ $0.post.locationMapItem })
                            .embeddedInNavigationView()
                            .environmentObject(viewModel)
                    }
                Spacer()
                AsyncButton {
                    searchDatasource.isPresented = true
                } label: {
                    SystemImage(.magnifyingglass)
                }
                Spacer()
                
                SystemImage(.sliderHorizontalBelowRectangle)
                    ._presentSheet {
                        PostsFilterView(viewModel.queries) { newValue in
                            viewModel.queries = newValue
                            await viewModel.performFirstFetch(filters: newValue)
                        }
                    }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .ignoresSafeArea(edges: .bottom)
        .background(.thinMaterial)
        ._flexible(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .blurReplace))
    }
}
