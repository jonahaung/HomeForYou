//
//  PostsCollectionViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/5/23.
//

import Foundation
import Combine
import XUI

class PostExplorerViewModel: ObservableObject, ViewModel {
    
    @Published var filterGroup: PostFiltersGroup = .init([], category: .current)
    @Published var alert: XUI._Alert?
    @Published var loading: Bool = false
    
    @Published var filters = [PostFilter]()
    @Published var posts = LazyList<Post>.empty
    @Published var displayDatas = [PostCellDisplayData]()
    private let cancelBag =  CancelBag()
    private let postFetcher = PostExplorerDatasource()
    
    init(_ filters: [PostFilter]) {
        self.filters = filters
        $filters
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                await self.performFirstFetch()
            }
            .store(in: cancelBag)
    }
    
    deinit {
        Log("Deinit")
    }
    func refreshable() async {
        await performFirstFetch()
    }
    
    func performFirstFetch() async {
        await setLoading(true)
        await postFetcher.reset()
        let postFilter = PostFiltersGroup(filters, category: .current)
        let query = postFilter.createQuery()
        do {
            let posts = try await postFetcher.performFetch(query: query)
            await setLoading(false)
            await setPosts(posts)
        } catch {
            await setLoading(false)
            await showAlert(.init(error: error))
        }
    }
    
    func performFetchMore() async {
        guard await postFetcher.canLoadMore() else { return }
        await setLoading(true)
        let postFilter = PostFiltersGroup(filters, category: .current)
        let query = postFilter.createQuery()
        do {
            try await Task.sleep(seconds: 0.5)
            let morePosts = try await postFetcher.fetchMore(query: query)
            let posts = (posts + morePosts)
            await setLoading(false)
            await setPosts(posts)
        } catch {
            await setLoading(false)
            await showAlert(.init(error: error))
        }
    }
    @MainActor
    private func setPosts(_ posts: [Post]) {
        self.posts = posts.lazyList
        self.displayDatas = posts.map{ .init($0) }
    }
}
