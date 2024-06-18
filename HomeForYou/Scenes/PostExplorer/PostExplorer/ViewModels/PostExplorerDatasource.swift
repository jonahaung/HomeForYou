//
//  PostFetcher.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import SwiftUI
import FirebaseFirestore
import XUI
import Combine

actor PostExplorerDatasource {
    
    enum FetchError: Error {
        case noMorePosts, currentlyLoading
    }
    
    let fetchSubject = PassthroughSubject<[PostCellDisplayData], Never>()
    let loadMoreSubject = PassthroughSubject<[PostCellDisplayData], Never>()
    
    private(set) var totalPostCount = 0
    private(set) var currentPostCount = 0
    private let fetchLimit = PostExplorer.Posts_Fetch_Limit
    private(set) var nextQuery: Query?
    
    func performFetch(query: Query) async throws {
        totalPostCount = try await query.count.getAggregation(source: AggregateSource.server).count.intValue
        let documents = try await query.limit(to: fetchLimit).getDocuments().documents
        let results = documents.compactMap { try? $0.decode(as: Post.self) }
        currentPostCount = documents.count
        let data = results.map{ PostCellDisplayData($0) }
        fetchSubject.send(data)
        if let lastSnapshot = documents.last {
            self.nextQuery = query.start(afterDocument: lastSnapshot)
        } else {
            self.nextQuery = nil
        }
    }
    
    func fetchMore() async throws  {
        guard let nextQuery else { throw FetchError.currentlyLoading }
        self.nextQuery = nil
        let limit: Int = min(totalPostCount - currentPostCount, fetchLimit)
        guard limit > 0 else {
            throw FetchError.noMorePosts
        }
        let documents = try await nextQuery.limit(to: limit).getDocuments().documents
        let results = documents.compactMap{ try? $0.decode(as: Post.self) }.uniqued()
        currentPostCount += documents.count
        let data = results.map{ PostCellDisplayData($0) }
        print(data.count)
        loadMoreSubject.send(data)
        if let lastSnapshot = documents.last {
            self.nextQuery = nextQuery.start(afterDocument: lastSnapshot)
        }
    }
    
    func canLoadMore() async -> Bool {
        totalPostCount > currentPostCount
    }
    func reset() async {
        currentPostCount = 0
        nextQuery = nil
        totalPostCount = 0
    }
}
