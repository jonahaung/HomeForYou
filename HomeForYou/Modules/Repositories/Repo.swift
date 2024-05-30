//
//  Repo.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/4/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

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

struct Repo {
    
    private static let db = Firestore.firestore()
    private static func collection<T: Repoable>(_ item: T) -> CollectionReference { db.collection(item.collectionPath) }
    
    // Add / Merge
    static func add<T: Repoable>(_ item: T, merge: Bool = true, _ completion: ((Error?) -> Void)?) {
        guard !item.id.isEmpty else {
            completion?(nil)
            return
        }
        do {
            _ = try collection(item).document(item.id).setData(item.toFirestoreData(), merge: merge, completion: completion)
        } catch {
            completion?(error)
        }
    }
    
    static func async_add<T: Repoable>(_ item: T, _ merge: Bool = true) async throws {
        guard !item.id.isEmpty else {
            throw XError.unknownError
        }
        try await collection(item).document(item.id).setData(item.toFirestoreData(), merge: merge)
    }
    
    // Fetch
    static func fetch<T: Repoable>(path: String, for id: String, as type: T.Type, _ completion: @escaping ((T?, Error?)) -> Void ) {
        guard !id.isEmpty else {
            completion((nil, XError.unknownError))
            return
        }
        db.collection(path).document(id).getDocument { snap, error in
            if let error {
                completion((nil, error))
                return
            }
            do {
                
                let item = try snap?.data(as: T.self)
                completion((item, nil))
            } catch {
                completion((nil, error))
            }
        }
    }
    
    static func async_fetch<T: Repoable>(path: String, for id: String, as type: T.Type) async throws -> T {
        return try await db.collection(path).document(id).getDocument(as: T.self)
    }
    
    static func async_fetch<T: Repoable>(query: Query) async throws -> [T] {
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }
    
    // Update
    static func update<T: Repoable>(path: String, for id: String, in type: T.Type, data: [PostKeys: Any], completion: ((Error?) -> Void)? = nil) {
        var fields = [String: Any]()
        data.forEach { (key, value) in
            fields[key.rawValue] = value
        }
        db.collection(path).document(id).updateData(fields, completion: completion)
    }
    
    static func async_update<T: Repoable>(path: String, for id: String, in type: T.Type, data: [PostKeys: Any]) async throws {
        var fields = [String: Any]()
        data.forEach { (key, value) in
            fields[key.rawValue] = value
        }
        try await db.collection(path).document(id).updateData(fields)
    }
    
    // Delege
    static func delete<T: Repoable>(_ item: T, _ completion: ((Error?) -> Void)? = nil) {
        guard !item.id.isEmpty else {
            completion?(nil)
            return
        }
        collection(item).document(item.id).delete(completion: completion)
    }
    
    // Observe
    static func listen<T: Repoable>(path: String, for id: String, onData: @escaping (_ item: T?) -> Void) -> ListenerRegistration {
        db.collection(path).document(id).addSnapshotListener { snapshot, error in
            if let error = error {
                print("failed to get snapshot for books", error)
                onData(nil)
                return
            }
            onData(try? snapshot?.decode(as: T.self))
        }
    }
    
    // Search
    static func search<T: Repoable>(path: String, key: String, value: String, as type: T.Type, limit: Int) async throws -> [T] {
        let query = db.collection(path)
            .whereField(key, isGreaterThanOrEqualTo: value)
            .whereField(key, isLessThan: value + "\u{f8ff}")
            .limit(to: limit)
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.decode(as: T.self) }
    }
    
    static func search<T: Repoable>(category: Category, words: [String], as type: T.Type, limit: Int) async throws -> [T] {
        return []
    }
}
