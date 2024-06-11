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
    @State private var selection: PostCellDisplayData?
    
    @ViewBuilder var largePostViews: some View {
        ForEach(viewModel.displayDatas) { data in
            InsetGroupList(selection: $selection, innerPadding: 0, outerPadding: 8) {
                PostSingleColumnLargeCell(data: data)
            }
            .equatable(by: data)
            .customTag(data)
        }
    }
    @ViewBuilder var listViews: some View {
        ForEach(viewModel.posts) { post in
            PostSingleColumnSmallCell()
                .environmentObject(post)
                .equatable(by: post)
                .customTag(post)
        }
        
    }
    @ViewBuilder var doubleColmViews: some View {
        ForEach(viewModel.posts) { post in
            PostDoubleColumnCell()
                .environmentObject(post)
                .equatable(by: post)
                .customTag(post)
        }
    }
    
    var body: some View {
        LodableScrollView(.vertical, showsIndicators: false, namespace: Self.typeName, content: {
            LazyVStack(alignment: .leading, spacing: 0) {
                if !viewModel.filters.isEmpty {
                    filteredTagsGroup
                }
                if gridAppearance.gridStyle != .TwoCol {
                    if gridAppearance.gridStyle == .Large {
                        InsetGroupList(selection: $selection, innerPadding: 0, outerPadding: 8) {
                            listViews.intersperse {
                                Divider().padding(.horizontal)
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                    } else {
                        largePostViews
                            .containerRelativeFrame(.horizontal)
                    }
                } else {
                    InsetGroupList(selection: $selection, innerPadding: 0, outerPadding: 4) {
                        WaterfallVList(columns: 2, spacing: 2) {
                            doubleColmViews
                        }
                    }
                    .containerRelativeFrame(.horizontal)
                }
            }
            .containerRelativeFrame(.horizontal)
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
            Log(item)
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
