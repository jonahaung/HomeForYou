//
//  PostsCollectionViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/5/23.
//

import Foundation
import Combine
import XUI

class PostsExplorerViewModel: ObservableObject {
    
    @Published var filters: [PostFilter]
    @Published var posts: Loadable<LazyList<Post>> = .loading
    private let cancelBag =  CancelBag()
    private var canLoadMore = false
    private let datasource = PostsDatasource()
    
    init(_ filters: [PostFilter]) {
        self.filters = filters
        $filters
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                guard self.posts != .loading else { return }
                self.posts = .loading
            }
            .store(in: cancelBag)
    }
    
    deinit {
        Log("Deinit")
    }
    
    func fetchPosts() {
        datasource.delegate = self
        fetch(filters: filters)
    }
    
    func refreshable() {
        fetchPosts()
    }
    
    private func fetch(filters: [PostFilter]) {
        canLoadMore = false
        let postFilter = PostFilters(filters, category: .current)
        datasource.performFetch(query: postFilter.createQuery())
    }
    
    @MainActor func fetchMoreIfNeeced() {
        guard canLoadMore else {
            print("all posts has been loaded")
            return
        }
        guard case let .loaded(value, isLoadingMore) = posts else {
            return
        }
        guard !isLoadingMore else {
            print("currently loading")
            return
        }
        canLoadMore = false
        print("loading more")
        posts = .loaded(value: value, isLoadingMore: true)
        let postFilter = PostFilters.init(filters, category: .current)
        datasource.fetchMoreIfNeeced(query: postFilter.createQuery())
    }
}

extension PostsExplorerViewModel: DatasourceDelegate {
    
    func datasourc(_ datasource: PostsDatasource, didLoaded items: [Post], canLoadMore: Bool) {
        posts = .loaded(value: items.lazyList, isLoadingMore: false)
        self.canLoadMore = canLoadMore
    }
    
    func datasource(_ datasource: PostsDatasource, didLoadedMore items: [Post], canLoadMore: Bool) {
        var oldItems = LazyList<Post>.empty
        if case let .loaded(value, _) = self.posts {
            oldItems = value
        }
        let new = (oldItems + items)
        self.posts = .loaded(value: new.lazyList, isLoadingMore: false)
        self.canLoadMore = canLoadMore
    }
}
