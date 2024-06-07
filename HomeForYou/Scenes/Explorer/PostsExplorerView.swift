//
//  PostsCollectionView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/5/23.
//

import SwiftUI
import XUI
import SFSafeSymbols

struct PostsExplorerView: View {
    
    @StateObject private var gridAppearance = GridAppearance()
    @StateObject private var viewModel: PostExplorerViewModel
    @StateObject private var searchDatasource = SearchDatasource()
    
    @Injected(\.ui) private var ui
    @Environment(\.editMode) private var editMode
    
    init(filters: [PostFilter]) {
        _viewModel = .init(wrappedValue: .init(filters))
    }
    var body: some View {
        LodableScrollView(.vertical, showsIndicators: false, namespace: Self.typeName, content: {
            VStack(alignment: .leading, spacing: 0) {
                if !viewModel.filters.isEmpty {
                    filteredTagsGroup
                }
                if !viewModel.loading && viewModel.posts.isEmpty {
                    InsetGroupList {
                        ContentUnavailableView.search
                    }
                }
                WaterfallVList(columns: gridAppearance.gridStyle == .TwoCol ? 2 : 1, spacing: gridAppearance.gridStyle == .TwoCol ? 3 : 0) {
                    switch gridAppearance.gridStyle {
                    case .Large:
                        ForEach(viewModel.displayDatas) { data in
                            PostSingleColumnLargeCell(data: data)
                               
                        }
                    case .TwoCol:
                        ForEach(viewModel.posts) { post in
                            PostDoubleColumnCell()
                                .environmentObject(post)
                        }
                    case .List:
                        ForEach(viewModel.posts) { post in
                            PostSingleColumnSmallCell()
                                .environmentObject(post)
                        }
                    }
                }
            }
            .animation(.interactiveSpring, value: viewModel.posts)
            .padding(.bottom, 70)
        }, onLoadMore: {
            guard await viewModel.loading == false else { return }
            await viewModel.performFetchMore()
        })
        .refreshable {
            guard !viewModel.loading else { return }
            await viewModel.refreshable()
        }
        .overlay(alignment: .bottom) {
            VStack {
                if viewModel.loading {
                    LoadingIndicator()
                        .padding()
                }
                if editMode?.wrappedValue == .active {
                    PostExplorerGridStylePicker()
                        .padding(.horizontal)
                }
                PostExplorerBottomToolbar()
            }
        }
        .navigationTitle("@explore")
        .toolbar {
            PostExplorerTopToolbar()
        }
        .magicButton(.backButton)
        .makeSearchable(searchDatasource)
        .background(Color.systemGroupedBackground)
        .environmentObject(viewModel)
        .environmentObject(gridAppearance)
        .environmentObject(searchDatasource)
        .onSearchSubmit { item in
            print(item)
        }
    }
}
private extension PostsExplorerView {
    private var filteredTagsGroup: some View {
        FilterTagsView(filters: $viewModel.filters)
            .padding(.leading)
            .padding(.vertical, 2)
            ._flexible(.horizontal)
            .equatable(by: viewModel.filters)
    }
}
