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
}
extension HomeDatasource {
    
    func performFetch(category: Category) async {
        await setLoading(true)
        featurePosts = await getFeaturePosts(category)
        latestPosts = await getLatestPosts(category)
        budgetPosts = await getBudgetPosts(category)
        lookings = await getLookingForPosts(category)
        await setLoading(false)
    }
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
            return try await Repo.async_fetch(query: query)
        } catch {
            await showAlert(.init(error: error))
            return []
        }
    }
}
