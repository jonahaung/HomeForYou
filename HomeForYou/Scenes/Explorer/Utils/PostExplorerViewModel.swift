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
    
    @Published var alert: XUI._Alert?
    @Published var loading: Bool = false

    @Published var filters = [PostQuery]()
    @Published var displayDatas = [PostCellDisplayData]()
    private let postFetcher = PostExplorerDatasource()
    
    init(_ filters: [PostQuery]) {
        self.filters = filters
        
//        $filters
//            .removeDuplicates()
//            .debounce(for: 0.1, scheduler: RunLoop.main)
//            .asyncSink { [weak self] value in
//                guard let self else { return }
//                await self.performFirstFetch(filters: filters)
//            }
//            .store(in: cancelBag)
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
        let query = QueryBuilder.createQuery(from: filters, category: .current)
        do {
            try await Task.sleep(seconds: 2)
            let posts = try await postFetcher.performFetch(query: query)
            await setPosts(posts.map{ PostCellDisplayData($0)} )
            
        } catch {
            await showAlert(.init(error: error))
        }
    }
    
    func performFetchMore(filters: [PostQuery]) async {
        guard await postFetcher.canLoadMore() else { return }
        await setLoading(true)
        let query = QueryBuilder.createQuery(from: filters, category: .current)
        do {
            try await Task.sleep(seconds: 2)
            let morePosts = try await postFetcher.fetchMore(query: query)
            let posts = (displayDatas + morePosts.map{ .init($0) })
            await setPosts(posts)
        } catch {
            await showAlert(.init(error: error))
        }
    }
    @MainActor
    private func setPosts(_ posts: [PostCellDisplayData]) {
        self.displayDatas = posts
        setLoading(false)
    }
}
extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
