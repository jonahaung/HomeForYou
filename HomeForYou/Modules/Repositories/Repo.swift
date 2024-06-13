//
//  Repo.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/4/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import XUI
enum XError: Error {
    case unknownError
    case imageUploadFailed
    case urlInvalid, jSONSerialization
    case attachments_isEmpty
    case user_not_logged_in
    case unwrapping
    case deeplink_unsupported_url
    var description: String {
        "\(type(of: self))"
    }
}

actor Repo {
    
    static let shared = Repo()
    
    private let db = Firestore.firestore()
    private func collection<T: Repoable>(_ item: T) -> CollectionReference { db.collection(item.collectionPath) }
    
    func async_add<T: Repoable>(_ item: T, _ merge: Bool = true) async throws {
        guard !item.id.isEmpty else {
            throw XError.unknownError
        }
        try await collection(item).document(item.id).setData(item.toFirestoreData(), merge: merge)
    }
    func async_fetch<T: Repoable>(path: String, for id: String, as type: T.Type) async throws -> T {
        return try await db.collection(path).document(id).getDocument(as: T.self)
    }
    func async_fetch<T: Repoable>(query: Query) async throws -> [T] {
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }
    func async_update<T: Repoable>(path: String, for id: String, in type: T.Type, data: [PostKey: Any]) async throws {
        var fields = [String: Any]()
        data.forEach { (key, value) in
            fields[key.rawValue] = value
        }
        try await db.collection(path).document(id).updateData(fields)
    }
    func async_delete<T: Repoable>(_ item: T) async throws {
        try await collection(item).document(item.id).delete()
    }
    // Search
    func search<T: Repoable>(path: String, key: String, value: String, as type: T.Type, limit: Int) async throws -> [T] {
        let query = db.collection(path)
            .whereField(key, isGreaterThanOrEqualTo: value)
            .whereField(key, isLessThan: value + "\u{f8ff}")
            .limit(to: limit)
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.decode(as: T.self) }
    }
}
