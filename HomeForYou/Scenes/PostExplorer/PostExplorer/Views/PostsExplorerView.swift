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
    
    @Injected(\.ui) private var ui
    
    init(query: CompoundQuery) {
        _viewModel = .init(wrappedValue: .init(query))
    }
    
    var body: some View {
        LodableScrollView(.vertical, scrollPositionID: $viewModel.scrollPositionID, showsIndicators: false, namespace: Self.typeName, content: {
            LazyVStack(alignment: .center, spacing: 5) {
                filteredTagsGroup
                    .id(FilterTagsView.typeName)
                if viewModel.displayData.isEmpty {
                    if !viewModel.loading {
                        ScrollViewList {
                            ContentUnavailableView("No posts found", systemImage: SFSymbol.rectangleAndTextMagnifyingglass.rawValue, description: Text(Lorem.paragraph))
                        }
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
                if viewModel.loading {
                    Color.clear
                        .frame(height: 50)
                        .hidden()
                        .overlay(alignment: .top) {
                            ProgressView()
                                .tint(Color.gray)
                        }
                }
            }
            .equatable(by: viewModel.reloadTag)
            .animation(.interactiveSpring(duration: 0.4, blendDuration: 0.4), value: viewModel.displayData)
        }, onLoadMore: {
            await viewModel.performFetchMore()
        })
        .background(Color.systemGroupedBackground)
        .magicButton(.constant(MagicButtonItem(.cameraFilters, .trailing, size: 44, animations: [.scale(0.7), .scale(1)], handleMagicButtonOnTap)))
        .navigationTitle("@explore")
        .safeAreaInset(edge: .bottom) {
            PostExplorerBottomToolbar()
        }
        .toolbar {
            PostExplorerTopToolbar()
        }
        .alertPresenter($viewModel.alert)
        .makeSearchable(searchDatasource)
        .sheet(isPresented: $viewModel.showPostFilterview) {
            PostFilterOptionView(query: $viewModel.query, showView: $viewModel.showPostFilterview)
        }
        .refreshable {
            await viewModel.refreshable(query: viewModel.query)
        }
        .onSearchSubmit { item in
            await handleSearchViewResults(item: item)
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
            .background(Color.systemGroupedBackground)
            .equatable(by: data)
            .id(data.id)
            .transition(.move(edge: .bottom))
            //            .scrollTransition { effect, phase in
            //                effect.offset(y: phase.isIdentity ? 0 : 100)
            //            }
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
    @ViewBuilder
    private var filteredTagsGroup: some View {
        FilterTagsView(items: $viewModel.query.values)
            .padding(5)
            ._flexible(.horizontal)
            .transition(.opacity)
    }
}
private extension PostsExplorerView {
    @MainActor
    private func handleMagicButtonOnTap() async  {
        viewModel.showPostFilterview = true
    }
}

private extension PostsExplorerView {
    
    private func handleSearchViewResults(item: SearchAction.ActionItem) async {
        @Injected(\.router) var router
        switch item {
        case .areaMap:
            router.presentFullScreen(.init(.planningAreaMap({ area in
                await MainActor.run {
                    viewModel.query = .init(.accurate, [.init(.area, area.rawValue.capitalized)])
                }
            })))
        case .mrtMap:
            router.presentFullScreen(.init(
                .mrtMap({ mrt in
                    await MainActor.run {
                        viewModel.query = .init(.accurate, [.init(.mrt, mrt.name)])
                    }
                })
            ))
        case .exploreAllPost:
            await MainActor.run {
                viewModel.query = .init(.accurate, [])
            }
        case .filter(let filters):
            await MainActor.run {
                viewModel.query = .init(.accurate, filters)
            }
        case .locationPickerMap:
            router.presentFullScreen(.init(.locationPickerMap({ locaion in
                await MainActor.run {
                    viewModel.query = .init(.accurate, [.init(.area, locaion.area.rawValue), .init(.mrt, locaion.nearestMRT.mrt)])
                }
            })))
        }
    }
}
