//
//  PostsDatasource.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import Foundation
import Combine
import XUI
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol DatasourceDelegate: AnyObject {
    @MainActor func datasourc(_ datasource: PostsDatasource, didLoaded items: [Post], canLoadMore: Bool)
    @MainActor func datasource(_ datasource: PostsDatasource, didLoadedMore items: [Post], canLoadMore: Bool)
}

class PostsDatasource: NSObject {

    var totalCount = 0
    var itemsCount = 0
    var fetchLimit = 2

    private var lastSnapshot: DocumentSnapshot?
    weak var delegate: DatasourceDelegate?

    func performFetch(query: Query) {
        reset()
        query.count.getAggregation(source: .server) { [weak self] snap, _ in
            guard let self else { return }
            self.totalCount = snap?.count.intValue ?? 0
            query.limit(to: self.fetchLimit).getDocuments {  [weak self] snap, _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    guard let documents = snap?.documents else { return }
                    let results = documents.compactMap { try? $0.decode(as: Post.self) }
                    self.itemsCount = results.count
                    self.lastSnapshot = documents.last
                    self.delegate?.datasource(self, didLoadedMore: results, canLoadMore: self.totalCount > self.itemsCount)
                }
            }
        }
    }

    @MainActor func fetchMoreIfNeeced(query: Query) {
        guard let lastSnapshot else {
            delegate?.datasource(self, didLoadedMore: [], canLoadMore: false)
            return
        }
        var query = query
        query = query.start(afterDocument: lastSnapshot)
        let limit = itemsCount > (totalCount - fetchLimit) ? (totalCount - itemsCount) : fetchLimit
        guard limit > 0 else {
            delegate?.datasource(self, didLoadedMore: [], canLoadMore: false)
            return
        }
        query.limit(to: limit).getDocuments { [weak self] snap, _ in
            guard let self else { return }
            DispatchQueue.main.async {
                guard let documents = snap?.documents else { return }
                let results = documents.compactMap { try? $0.decode(as: Post.self) }
                self.itemsCount += results.count
                self.lastSnapshot = documents.last
                self.delegate?.datasource(self, didLoadedMore: results, canLoadMore: self.totalCount > self.itemsCount)
            }
        }
    }

    func reset() {
        itemsCount = 0
        lastSnapshot = nil
        totalCount = 0
    }
    deinit {
        Log("")
    }
}
