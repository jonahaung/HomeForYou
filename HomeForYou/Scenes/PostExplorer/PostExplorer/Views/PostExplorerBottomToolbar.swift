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
        VStack(spacing: 0) {
//            PostExplorerGridStylePicker(reloadTag: $viewModel.reloadTag)
//                .transition(.move(edge: .bottom).combined(with: .blurReplace))
            HStack {
                SystemImage(.globeDesk)
                    .padding(.horizontal)
                    ._presentSheet {
                        LocationMap(viewModel.displayData.map{ $0.post.locationMapItem })
                            .embeddedInNavigationView()
                            .environmentObject(viewModel)
                            .presentationDetents([.medium])
                    }
                Spacer()
                Text("Total \(viewModel.totalItems) items")
                    .font(.footnote)
                    .italic()
                    .foregroundStyle(.secondary)
                Spacer()
                AsyncButton {
                    searchDatasource.isPresented = true
                } label: {
                    SystemImage(.magnifyingglass)
                        .padding(.horizontal)
                }
            }
            .frame(height: 35)
            .imageScale(.large)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .ignoresSafeArea(edges: .bottom)
        .background(.bar)
        ._flexible(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .blurReplace))
    }
}
