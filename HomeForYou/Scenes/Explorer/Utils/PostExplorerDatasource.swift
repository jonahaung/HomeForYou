//
//  PostFetcher.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import SwiftUI
import FirebaseFirestore
import XUI

actor PostExplorerDatasource {
    
    private var totalPostCount = 0
    private var currentPostCount = 0
    private var fetchLimit = PostExplorer.Posts_Fetch_Limit
    private var lastSnapshot: DocumentSnapshot?
    
    func performFetch(query: Query) async throws -> [Post] {
        await reset()
        totalPostCount = try await query.count.getAggregation(source: .server).count.intValue
        let documents = try await query.limit(to: fetchLimit).getDocuments().documents
        let results = documents.compactMap { try? $0.decode(as: Post.self) }
        currentPostCount = documents.count
        lastSnapshot = documents.last
        return results
    }
    
    func fetchMore(query: Query) async throws -> [Post] {
        var query = query
        if let lastSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        } else {
            throw(XError.unknownError)
        }
        
        let limit: Int = {
            if (totalPostCount - currentPostCount) < fetchLimit {
                return fetchLimit
            }
            return fetchLimit
        }()
        
        let documents = try await query.limit(to: limit).getDocuments().documents
        let posts = documents.compactMap{ try? $0.decode(as: Post.self) }.uniqued()
        currentPostCount += documents.count
        lastSnapshot = currentPostCount == totalPostCount ? nil : documents.last
        return posts
    }
    
    func canLoadMore() async -> Bool {
        totalPostCount != currentPostCount
    }
    func reset() async {
        currentPostCount = 0
        lastSnapshot = nil
        totalPostCount = 0
    }
}
