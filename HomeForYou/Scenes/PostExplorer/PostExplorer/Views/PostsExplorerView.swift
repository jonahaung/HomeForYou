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
    @StateObject private var storage = PostQueryStorage()
    
    @Injected(\.ui) private var ui
    
    init(queries: [PostQuery]) {
        _viewModel = .init(wrappedValue: .init(queries))
    }
    
    var body: some View {
        ZStack {
            Color.systemGroupedBackground
                .ignoresSafeArea()
            LodableScrollView(.vertical, showsIndicators: true, namespace: Self.typeName, content: {
                LazyVStack(alignment: .leading, spacing: 0) {
                    filteredTagsGroup
                    if viewModel.displayDatas.isEmpty && !viewModel.canLoadMore {
                        ContentUnavailableView("No Posts Found", systemImage: "doc.questionmark.fill")
                    }
                    if gridAppearance .gridStyle != .TwoCol {
                        if gridAppearance.gridStyle == .Large {
                            ScrollViewList(innerPadding: 0, outerPadding: 8) {
                                listViews.intersperse {
                                    Divider().padding(.horizontal)
                                }
                            }
                        } else {
                            largePostViews
                        }
                    } else {
                        ScrollViewList(innerPadding: 0, outerPadding: 4) {
                            WaterfallVList(columns: 2, spacing: 2) {
                                doubleColmViews
                            }
                        }
                    }
                }
                .padding(.bottom, 50)
                .equatable(by: viewModel.reloadTag)
            }, onLoadMore: {
                guard await viewModel.loading == false else { return }
                await viewModel.performFetchMore()
            })
            .refreshable {
                guard !viewModel.loading else { return }
                viewModel.refreshable(filters: viewModel.queries)
            }
            ._flexible(.all)
        }
        .task(id: viewModel.queries, debounceTime: .seconds(0.2)) {
            await MainActor.run {
                viewModel.performFirstFetch(filters: viewModel.queries)
            }
        }
        .magicButton(.init(.cameraFilters, .trailing, handleMagicButtonAction))
        .navigationTitle("@explore")
        .overlay(alignment: .bottom) {
            PostExplorerBottomToolbar()
        }
        .toolbar {
            PostExplorerTopToolbar()
        }
        .alertPresenter($viewModel.alert)
        .makeSearchable(searchDatasource)
        .sheet(isPresented: $viewModel.showPostFilterview) {
            PostFilterOptionView(quries: $viewModel.queries)
        }
        .environmentObject(viewModel)
        .environmentObject(gridAppearance)
        .environmentObject(searchDatasource)
        .environmentObject(storage)
    }
    @MainActor
    private func handleMagicButtonAction() async  {
        viewModel.showPostFilterview = true
    }
    @ViewBuilder private var largePostViews: some View {
        ForEach(viewModel.displayDatas) { data in
            ScrollViewList(innerPadding: 0, outerPadding: 8) {
                PostSingleColumnLargeCell(data: data)
            }
            .equatable(by: data)
        }
    }
    @ViewBuilder private var listViews: some View {
        ForEach(viewModel.displayDatas) { post in
            PostSingleColumnSmallCell()
                .environmentObject(post.post)
                .equatable(by: post)
        }
    }
    @ViewBuilder private var doubleColmViews: some View {
        ForEach(viewModel.displayDatas) { post in
            PostDoubleColumnCell()
                .environmentObject(post.post)
                .equatable(by: post)
        }
    }
}
private extension PostsExplorerView {
    private var filteredTagsGroup: some View {
        FilterTagsView(queries: $viewModel.queries)
            .padding(.leading)
            .padding(.vertical, 2)
            ._flexible(.horizontal)
            .animation(.interactiveSpring, value: viewModel.queries)
            .equatable(by: viewModel.queries)
    }
}
