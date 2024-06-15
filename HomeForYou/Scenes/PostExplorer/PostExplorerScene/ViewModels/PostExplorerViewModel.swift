//
//  PostsCollectionViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/5/23.
//

import SwiftUI
import Combine
import XUI
import MapKit
import Contacts

class PostExplorerViewModel: ObservableObject, ViewModel {
    
    @Published var reloadTag = 0
    
    @Published var alert: XUI._Alert?
    @Published var loading: Bool = false
    @Published var showPostFilterview = false
    var queries = [PostQuery]()
    var displayDatas = [PostCellDisplayData]()
    var canLoadMore: Bool = true
    private let postFetcher = PostExplorerDatasource()
    
    init(_ filters: [PostQuery]) {
        self.queries = filters
    }
    
    deinit {
        Log("Deinit")
    }
    func refreshable(filters: [PostQuery]) async {
        await performFirstFetch(filters: filters)
    }
    
    func performFirstFetch(filters: [PostQuery]) async {
        await setLoading(true)
        await postFetcher.reset()
        let query = FireQueryBuilder.build(from: filters, category: .current)
        do {
            let posts = try await postFetcher.performFetch(query: query)
            canLoadMore = await postFetcher.canLoadMore()
            await setPosts(posts.map{ PostCellDisplayData($0)} )
        } catch {
            await showAlert(.init(error: error))
        }
    }
    
    func performFetchMore(filters: [PostQuery]) async {
        guard await postFetcher.canLoadMore() else { return }
        await setLoading(true)
        let query = FireQueryBuilder.build(from: filters, category: .current)
        do {
            try await Task.sleep(seconds: 1)
            let morePosts = try await postFetcher.fetchMore(query: query)
            let posts = (displayDatas + morePosts.map{ .init($0) })
            canLoadMore = await postFetcher.canLoadMore()
            await setPosts(posts)
        } catch {
            await showAlert(.init(error: error))
        }
    }
    @MainActor
    private func setPosts(_ posts: [PostCellDisplayData]) {
        self.displayDatas = posts
        setLoading(false)
        reloadUI()
    }
    @MainActor
    func reloadUI() {
        reloadTag += 1
    }
}
