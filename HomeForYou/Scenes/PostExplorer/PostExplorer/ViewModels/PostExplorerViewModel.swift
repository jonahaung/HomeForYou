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
    @Published var showPostFilterview = false
    @Published var query: CompoundQuery
    var scrollPositionID: String?
    var alert: XUI._Alert?
    var loading = true
    var displayData = [PostCellDisplayData]()
    var totalItems = Int.zero
    private let postFetcher = PostExplorerDatasource()
    private let cancelBag = CancelBag()
    
    init(_ query: CompoundQuery) {
        self.query = query
        postFetcher.fetchSubject
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.current)
            .asyncSink { [weak self] data in
                guard let self else { return }
                await MainActor.run {
                    self.scrollPositionID = FilterTagsView.typeName
                }
                try? await Task.sleep(seconds: 0.3)
                await self.setPosts(data)
                totalItems = await postFetcher.totalPostCount
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
        await setPosts([])
        await performFirstFetch(query: query)
    }
    private func performFirstFetch(query: CompoundQuery) async {
        await postFetcher.reset()
        task = Task(priority: .background) {
            if Task.isCancelled == true { return }
            let query = FirebaseQueryBuilder.build(from: query, category: .current)
            do {
                let loadingTask = Task { @MainActor in
                    if Task.isCancelled == true { return }
                    setLoading(true)
                }
                if Task.isCancelled == true { return }
                try await postFetcher.performFetch(query: query)
                loadingTask.cancel()
            } catch {
                await showAlert(.init(error: error))
            }
        }
    }
    
    func performFetchMore() async {
        guard await postFetcher.canLoadMore() else { return }
        guard task == nil else {
            await task?.value
            return
        }
        task = Task(priority: .background) {
            if Task.isCancelled == true { return }
            do {
                let loadingTask = Task { @MainActor in
                    if Task.isCancelled { return }
                    setLoading(true)
                }
                if Task.isCancelled == true { return }
                try await postFetcher.fetchMore()
                loadingTask.cancel()
            } catch {
                
                await setError(error)
            }
        }
    }
    @MainActor
    private func setPosts(_ posts: [PostCellDisplayData]) {
        task?.cancel()
        task = nil
        scrollPositionID = nil
        displayData = posts
        setLoading(false)
    }
    
    @MainActor func reloadUI() {
        self.reloadTag += 1
        self.objectWillChange.send()
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
            case .currentlyLoading:
                print("currently Loading")
                setLoading(true)
            }
        } else {
            showAlert(.init(error: error))
        }
    }
}
