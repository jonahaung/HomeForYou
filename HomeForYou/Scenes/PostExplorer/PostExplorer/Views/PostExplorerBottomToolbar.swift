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
        VStack {
//            PostExplorerGridStylePicker(reloadTag: $viewModel.reloadTag)
//                .transition(.move(edge: .bottom).combined(with: .blurReplace))
            HStack {
                SystemImage(.mapCircle)
                    .imageScale(.large)
                    .padding(.horizontal)
                    ._presentSheet {
                        LocationMap(viewModel.displayData.map{ $0.post.locationMapItem })
                            .embeddedInNavigationView()
                            .environmentObject(viewModel)
                    }
                Spacer()
                
                AsyncButton {
                    searchDatasource.isPresented = true
                } label: {
                    SystemImage(.textMagnifyingglass)
                        .imageScale(.large)
                        .padding(.horizontal)
                }
            }
            .frame(height: 35)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .ignoresSafeArea(edges: .bottom)
        .background(.bar)
        ._flexible(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .blurReplace))
    }
}
