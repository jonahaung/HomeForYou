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
    @State private var magicButton = MagicButtonItem(.clockFill, .center, 25)
    @Injected(\.ui) private var ui
    @Environment(\.editMode) private var editMode
    
    init(filters: [PostQuery]) {
        _viewModel = .init(wrappedValue: .init(filters))
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
                        .containerRelativeFrame(.horizontal)
                    } else {
                        largePostViews
                            .containerRelativeFrame(.horizontal)
                    }
                } else {
                    ScrollViewList(innerPadding: 0, outerPadding: 4) {
                        WaterfallVList(columns: 2, spacing: 2) {
                            doubleColmViews
                        }
                    }
                    .containerRelativeFrame(.horizontal)
                }
            }
            .containerRelativeFrame(.horizontal)
            .padding(.bottom, 70)
            .equatable(by: viewModel.loading)
            .animation(.snappy, value: viewModel.loading)
        }, onLoadMore: {
            guard await viewModel.loading == false else { return }
            await viewModel.performFetchMore(filters: viewModel.filters)
        })
        .refreshable {
            guard !viewModel.loading else { return }
            await viewModel.refreshable(filters: viewModel.filters)
        }
        .overlay(alignment: .bottom) {
            VStack {
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
        .alertPresenter($viewModel.alert)
        .magicButton($magicButton)
        .makeSearchable(searchDatasource)
        .background(Color.systemGroupedBackground)
        .environmentObject(viewModel)
        .environmentObject(gridAppearance)
        .environmentObject(searchDatasource)
        .onSearchSubmit { item in
            Log(item)
        }
        .task(
            id: viewModel.filters,
            priority: .background,
            debounceTime: .seconds(
                0
            )
        ) {
            await viewModel.performFirstFetch(
                filters: viewModel.filters
            )
        }
        .onChange(of: viewModel.loading) { oldValue, newValue in
            let symbol = newValue ? SFSymbol.arrowTriangle2CirclepathCircleFill : .line2HorizontalDecreaseCircleFill
            let size = newValue ? CGFloat(30) : 36
            let alignment = newValue ? Alignment.center : .trailing
            magicButton.update(symbol: symbol, alignment: alignment, size: size, animations: newValue ? CardinalPoint.allCases.map{ PhaseAnimationType.rotate($0)} : [.scale(1), .scale(1.1)]) {
                await viewModel.refreshable(filters: viewModel.filters)
            }
        }
    }
}
private extension PostsExplorerView {
    private var filteredTagsGroup: some View {
        FilterTagsView(queries: $viewModel.filters)
            .padding(.leading)
            .padding(.vertical, 2)
            ._flexible(.horizontal)
            .equatable(by: viewModel.filters)
    }
}
