//
//  PostsCollectionView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/5/23.
//

import SwiftUI
import XUI

struct PostsExplorerView: View {
    
    @StateObject private var gridAppearance = GridAppearance()
    @StateObject private var viewModel: PostExplorerViewModel
    @StateObject private var searchDatasource = SearchDatasource()
    @State private var magicButton = MagicButtonItem(.clockFill, .trailing, 25)
    @StateObject private var storage = PostQueryStorage()
    
    @Injected(\.ui) private var ui
    
    init(queries: [PostQuery]) {
        _viewModel = .init(wrappedValue: .init(queries))
    }
    
    var body: some View {
        LodableScrollView(.vertical, showsIndicators: false, namespace: Self.typeName, content: {
            LazyVStack(alignment: .leading, spacing: 0) {
                filteredTagsGroup
                if gridAppearance.gridStyle != .TwoCol {
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
                if viewModel.displayDatas.isEmpty {
                    ContentUnavailableView("No Posts Found", systemImage: "doc.questionmark.fill")
                }
                VStack(alignment: .center) {
                    if viewModel.canLoadMore {
                        LoadingIndicator()
                        Spacer()
                    }
                }
                .frame(height: 70)
                ._flexible(.horizontal)
            }
            .equatable(by: viewModel.reloadTag)
            .animation(.spring, value: viewModel.loading)
            .containerRelativeFrame(.horizontal)
            .allowsHitTesting(!viewModel.loading)
        }, onLoadMore: {
            guard await viewModel.loading == false else { return }
            await viewModel.performFetchMore(filters: viewModel.queries)
        })
        .refreshable {
            guard !viewModel.loading else { return }
            await viewModel.refreshable(filters: viewModel.queries)
        }
        .task(id: viewModel.queries, debounceTime: .seconds(0.2), {
            await viewModel.performFirstFetch(
                filters: viewModel.queries
            )
        })
        .onSearchSubmit { item in
            Log(item)
        }
        .onChange(of: viewModel.reloadTag) { oldValue, newValue in
            magicButton.updateAction {
                print("hahahahaha")
            }
            magicButton.loading(viewModel.loading, action: handleMagicButtonAction)
        }
        .navigationTitle("@explore")
        .overlay(alignment: .bottom) {
            PostExplorerBottomToolbar()
        }
        .toolbar {
            PostExplorerTopToolbar()
        }
        .alertPresenter($viewModel.alert)
        .magicButton(.constant(magicButton))
        .makeSearchable(searchDatasource)
        .sheet(isPresented: $viewModel.showPostFilterview) {
            PostsFilterView(viewModel.queries) { newValue in
                await self.viewModel.performFirstFetch(filters: newValue)
            }
        }
        .background(Color.systemGroupedBackground)
        .environmentObject(viewModel)
        .environmentObject(gridAppearance)
        .environmentObject(searchDatasource)
        .environmentObject(storage)
    }
    @MainActor
    private func handleMagicButtonAction() async throws  {
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
            .equatable(by: viewModel.queries)
    }
}
