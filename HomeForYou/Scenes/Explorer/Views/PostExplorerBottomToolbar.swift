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
    var body: some View {
        HStack {
            SystemImage(.map, 25)
                ._presentSheet {
                    LocationMap(viewModel.displayDatas.map{ $0.post.locationMapItem })
                        .embeddedInNavigationView()
                        .environmentObject(viewModel)
                }
            Spacer()
            AsyncButton {
                searchDatasource.isPresented = true
            } label: {
                SystemImage(.magnifyingglass, 25)
            }
            Spacer()
            
            SystemImage(.sliderHorizontalBelowRectangle, 25)
                ._presentSheet {
                    PostsFilterView($viewModel.filters)
                }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .ignoresSafeArea(edges: .bottom)
        .background(.bar)
        ._flexible(.horizontal)
    }
}
