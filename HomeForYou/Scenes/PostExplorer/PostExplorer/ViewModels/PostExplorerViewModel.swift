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
    @Published var showPostFilterview = false
    @Published var queries = [PostQuery]()
    
    var alert: XUI._Alert?
    var loading: Bool = false
    var displayDatas = [PostCellDisplayData]()
    var canLoadMore: Bool = true
    private let postFetcher = PostExplorerDatasource()
    let cancelBag = CancelBag()
    init(_ filters: [PostQuery]) {
        self.queries = filters
        postFetcher.fetchSubject
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .asyncSink { [weak self] data in
                guard let self else { return }
                await self.setPosts(data)
            }
            .store(in: cancelBag)
        postFetcher.loadMoreSubject
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .asyncSink { [weak self] newData in
                guard let self else { return }
                let data = (self.displayDatas + newData)
                await self.setPosts(data)
            }
            .store(in: cancelBag)
    }
    private var task: Task<(), Never>?
    deinit {
        Log("Deinit")
    }
    func refreshable(filters: [PostQuery]) {
        performFirstFetch(filters: filters)
    }
    func performFirstFetch(filters: [PostQuery]) {
        task?.cancel()
        task = Task(priority: .background) {
            if Task.isCancelled == true { return }
            await postFetcher.reset()
            let loadingTask = Task { @MainActor in
                if Task.isCancelled { return }
                setLoading(true)
            }
            let query = FireQueryBuilder.build(from: filters, category: .current)
            do {
                if Task.isCancelled == true { return }
                try await postFetcher.performFetch(query: query)
                loadingTask.cancel()
            } catch {
                loadingTask.cancel()
                await showAlert(.init(error: error))
            }
        }
    }
    
    func performFetchMore() {
        guard canLoadMore else { return }
        guard task == nil else { return }
        task?.cancel()
        task = Task(priority: .background) {
            if Task.isCancelled == true { return }
            let loadingTask = Task { @MainActor in
                if Task.isCancelled { return }
                setLoading(true)
            }
            do {
//                try await Task.sleep(seconds: 0.2)
//                if Task.isCancelled == true { return }
                try await postFetcher.fetchMore()
                loadingTask.cancel()
            } catch {
                loadingTask.cancel()
                await setError(error)
            }
        }
    }
    @MainActor
    private func setPosts(_ posts: [PostCellDisplayData]) {
        task?.cancel()
        task = nil
        displayDatas = posts
        setLoading(false)
        reloadUI()
    }
    @MainActor
    private func setError(_ error: Error) {
        if let error = error as? PostExplorerDatasource.FetchError {
            switch error {
            case .noMorePosts:
                setLoading(false)
                canLoadMore = false
            case .currentlyLoading:
                print("currently Loading")
                break
            }
        } else {
            showAlert(.init(error: error))
        }
    }
    @MainActor
    func reloadUI() {
        reloadTag += 1
    }
    func showAlert(_ alert: _Alert) {
        self.alert = alert
        task = nil
    }
}
