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
    @StateObject private var storage = FirebasePostQueryStorage()
    
    @State private var magicButtonItem = MagicButtonItem(.cameraFilters, .trailing, size: 44)
    @Injected(\.ui) private var ui
    
    init(query: CompoundQuery) {
        _viewModel = .init(wrappedValue: .init(query))
    }
    
    var body: some View {
        LodableScrollView(.vertical, showsIndicators: false, namespace: Self.typeName, content: {
            LazyVStack(alignment: .leading, spacing: 0) {
                filteredTagsGroup
                if viewModel.displayData.isEmpty && !viewModel.loading {
                    ScrollViewList {
                        ContentUnavailableView("No Posts Found", systemImage: "doc.questionmark.fill")
                    }
                }
                switch gridAppearance.gridStyle {
                case .Large:
                    largePostViews
                case .TwoCol:
                    doubleColmViews
                case .List:
                    listViews
                }
            }
            .padding(.bottom, 50)
            .equatable(by: viewModel.reloadTag)
        }, onLoadMore: {
            await viewModel.performFetchMore()
        })
        .background(Color.systemGroupedBackground)
        .onChange(of: viewModel.reloadTag) { _, _ in
            magicButtonItem.update(animations: viewModel.loading ? [.rotate(.north), .rotate(.north_360)] : [], action: handleMagicButtonOnTap)
        }
        .magicButton($magicButtonItem)
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
            PostFilterOptionView(query: $viewModel.query)
        }
        .refreshable {
            guard !viewModel.loading else { return }
            await viewModel.refreshable(query: viewModel.query)
        }
        .environmentObject(viewModel)
        .environmentObject(gridAppearance)
        .environmentObject(searchDatasource)
        .environmentObject(storage)
    }
}
private extension PostsExplorerView {
    @ViewBuilder private var largePostViews: some View {
        ForEach(viewModel.displayData) { data in
            ScrollViewList(innerPadding: 0, outerPadding: 8) {
                PostSingleColumnLargeCell(data: data)
            }
        }
    }
    @ViewBuilder private var listViews: some View {
        ScrollViewList(innerPadding: 0, outerPadding: 8) {
            ForEach(viewModel.displayData) { post in
                PostSingleColumnSmallCell()
                    .environmentObject(post.post)
                    .equatable(by: post)
            }
        }
    }
    @ViewBuilder private var doubleColmViews: some View {
        ScrollViewList(innerPadding: 0, outerPadding: 4) {
            WaterfallVList(columns: 2, spacing: 2) {
                ForEach(viewModel.displayData) { post in
                    PostDoubleColumnCell()
                        .environmentObject(post.post)
                        .equatable(by: post)
                }
            }
        }
    }
}
private extension PostsExplorerView {
    private var filteredTagsGroup: some View {
        FilterTagsView(items: $viewModel.query.values)
            .padding(.leading)
            .padding(.vertical, 2)
            ._flexible(.horizontal)
    }
}
private extension PostsExplorerView {
    @MainActor
    private func handleMagicButtonOnTap() async  {
        viewModel.showPostFilterview = true
        viewModel.reloadUI()
    }
}
