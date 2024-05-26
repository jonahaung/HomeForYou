//
//  PostsCollectionView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/5/23.
//

import SwiftUI
import XUI
import NukeUI

struct PostsExplorerView: View {
    
    @Injected(\.router) private var router
    @Injected(\.ui) private var ui
    @StateObject private var appearance = GridAppearance()
    @StateObject private var model: PostsExplorerViewModel
    @Environment(MagicButtonViewModel.self) private var magicButton
    
    
    init(filters: [PostFilter]) {
        _model = .init(wrappedValue: .init(filters))
    }
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            
    }
    
    @ViewBuilder var content: some View {
        switch model.posts {
        case .loading:
            loadingView
        case let .loaded(posts, canLoadMore):
            loadedView(posts, canLoadMore)
        case let .failed(error):
            failedView(error)
        }
    }
    private var loadingView: some View {
        LoadingIndicator()
            ._onAppear(after: 0.2) {
                model.fetchPosts()
            }
    }
    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            model.fetchPosts()
        })
    }
    
    @ViewBuilder private func loadedView(_ posts: LazyList<Post>, _ isLoadingMore: Bool) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                switch appearance.gridStyle {
                case .Large:
                    headerBar
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 1),
                        spacing: 0
                    ) {
                        ForEach(posts) { post in
                            PostSingleColumnLargeCell()
                                .environmentObject(post)
                        }
                    }
                case .List:
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(posts) { post in
                                PostSingleColumnSmallCell()
                                    .environmentObject(post)
                            }
                        } header: {
                            headerBar
                        }
                    }
                case .TwoCol:
                    headerBar
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 2),
                        spacing: 0
                    ) {
                        ForEach(posts) { post in
                            PostDoubleColumnCell()
                                .environmentObject(post)
                        }
                    }
                    .safeAreaPadding(4)
                }
            }
        }
        .background(ui.colors.systemGroupedBackground, ignoresSafeAreaEdges: .bottom)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                SystemImage(.magnifyingglass)
                    ._presentFullScreen {
                        SearchingView()
                    }
                SystemImage(.sliderHorizontalBelowRectangle)
                    ._presentSheet {
                        PostsFilterView($model.filters)
                    }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                SystemImage(.mappinCircleFill)
                    ._presentSheet {
                        if let posts = model.posts.value {
                            LocationMap(posts.map{ $0.locationMapItem })
                                .embeddedInNavigationView()
                        }
                    }
                Spacer()
                gridStylePicker()
            }
        }
        .magicButton(.backButton)
        .shouldLoadMore(bottomDistance: .absolute(0.0)) {
            if !isLoadingMore {
                model.fetchMoreIfNeeced()
            }
        }
        .refreshable {
            model.posts = .loading
        }
    }
}

private extension PostsExplorerView {
    
    private var headerBar: some View {
        FilterTagsView(filters: $model.filters)
            .padding(.leading)
            .padding(.vertical, 2)
            ._flexible(.horizontal)
            .equatable(by: model.filters)
    }
    
    private func gridStylePicker() -> some View {
        Picker("Grid Style", selection: $appearance.gridStyle) {
            ForEach(GridStyle.allCases) { each in
                Label(each.title, systemImage: each.iconName)
                    .tag(each)
                    .imageScale(.small)
            }
        }
        .onChange(of: appearance.gridStyle) { _, _ in
            model.refreshable()
        }
    }
}
