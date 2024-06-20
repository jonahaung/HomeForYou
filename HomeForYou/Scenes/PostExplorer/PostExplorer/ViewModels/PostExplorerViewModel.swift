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
    
    var reloadTag = 0
    var showPostFilterview = false
    @Published var query: CompoundQuery
    
    var alert: XUI._Alert?
    var loading = true
    var displayData = [PostCellDisplayData]()
    var canLoadMore: Bool = true
    
    private let postFetcher = PostExplorerDatasource()
    private let cancelBag = CancelBag()
    
    init(_ query: CompoundQuery) {
        self.query = query
        postFetcher.fetchSubject
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.current)
            .asyncSink { [weak self] data in
                guard let self else { return }
                await self.setPosts(data)
            }
            .store(in: cancelBag)
        postFetcher.loadMoreSubject
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.current)
            .asyncSink { [weak self] newData in
                guard let self else { return }
                let data = (self.displayData + newData)
                await self.setPosts(data)
            }
            .store(in: cancelBag)
        self.$query
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.current)
            .asyncSink { [weak self] value in
                guard let self else { return }
                await self.performFirstFetch(query: value)
            }
            .store(in: cancelBag)
    }
    private var task: Task<(), Never>?
    deinit {
        Log("Deinit")
    }
    func refreshable(query: CompoundQuery) async {
        await performFirstFetch(query: query)
    }
    
    private func performFirstFetch(query: CompoundQuery) async {
        await postFetcher.reset()
        task?.cancel()
        task = Task(priority: .background) {
            if Task.isCancelled == true { return }
            let query = FireQueryBuilder.build(from: query, category: .current)
            do {
                let loadingTask = Task { @MainActor in
                    if Task.isCancelled { return }
                    setLoading(true)
                }
                if Task.isCancelled == true { return }
                try await postFetcher.performFetch(query: query)
                loadingTask.cancel()
                canLoadMore = true
            } catch {
                await showAlert(.init(error: error))
            }
        }
    }
    
    func performFetchMore() async {
        guard canLoadMore else { return }
        guard task == nil else {
            await task?.value
            return
        }
        task = Task(priority: .background) {
            if Task.isCancelled == true { return }
            let loadingTask = Task { @MainActor in
                if Task.isCancelled { return }
                setLoading(true)
            }
            do {
                if Task.isCancelled == true { return }
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
        displayData = posts
        task?.cancel()
        task = nil
        setLoading(false)
    }
    
    @MainActor func reloadUI() {
        reloadTag += 1
        objectWillChange.send()
    }
    func showAlert(_ alert: _Alert) {
        self.alert = alert
        task = nil
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
}
