//
//  HomeDatasource.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import SwiftUI
import FirebaseFirestore
import XUI

@Observable
final class HomeDatasource: ViewModel {
    
    var featurePosts = [Post]()
    var latestPosts = [Post]()
    var budgetPosts = [Post]()
    var lookings = [Looking]()
    var alert: XUI._Alert?
    var loading: Bool = false
    
    private let repo = Repo()
}
extension HomeDatasource {
    
    func performFetch(_ category: Category, delay: Bool = false) async {
        await setLoading(true)
        if delay {
            try? await Task.sleep(seconds: 1)
        }
        let featurePosts = await getFeaturePosts(category)
        await MainActor.run {
            self.featurePosts = featurePosts
        }
        let latestPosts = await getLatestPosts(category)
        await MainActor.run {
            self.latestPosts = latestPosts
        }
        let budgetPosts = await getBudgetPosts(category)
        await MainActor.run {
            self.budgetPosts = budgetPosts
        }
        let lookings = await getLookingForPosts(category)
        await MainActor.run {
            self.lookings = lookings
            setLoading(false)
        }
    }
    func refresh() {
        Task {
            await performFetch(.current, delay: true)
        }
    }
}

extension HomeDatasource {
    private func getFeaturePosts(_ category: Category) async -> [Post] {
        let query = collectionReference(category).limit(to: 7)
        return await getPosts(for: query)
    }
    private func getLatestPosts(_ category: Category) async -> [Post] {
        let query = collectionReference(category).order(by: PostKeys.createdAt.rawValue, descending: true).limit(to: 4)
        return await getPosts(for: query)
    }
    private func getBudgetPosts(_ category: Category) async -> [Post] {
        let query = collectionReference(category).order(by: PostKeys.price.rawValue, descending: false).limit(to: 6)
        return await getPosts(for: query)
    }
    private func getLookingForPosts(_ category: Category) async -> [Looking] {
        let query = Firestore.firestore().collection("looking").limit(to: 10)
        return await getPosts(for: query)
    }
    // Helpers
    private func collectionReference(_ category: Category) -> CollectionReference {
        Firestore.firestore().collection(category.rawValue)
    }
    private func getPosts<Item: Repoable>(for query: Query) async -> [Item] {
        do {
            return try await repo.async_fetch(query: query)
        } catch {
            await showAlert(.init(error: error))
            return []
        }
    }
}
