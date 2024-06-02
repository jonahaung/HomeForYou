//
//  PostingProgress.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/2/23.
//

import SwiftUI
import FirebaseStorage
import XUI
import PhoneNumberKit

struct PostUploader {

    static func post(_ post: inout MutablePost, author: PersonInfo) async throws {
        guard !post.attachments.isEmpty else {
            throw XError.attachments_isEmpty
        }
        try sinitize(&post, author)
        post.attachments = try await upload(attachments: post.attachments, postID: post.id, category: post.category)
        try await Repo.shared.async_add(post, false)
    }

    private static func upload(attachments: [XAttachment], postID: String, category: Category) async throws -> [XAttachment] {
        return try await withThrowingTaskGroup(of: XAttachment.self) { group in
            for attachment in attachments {
                group.addTask {
                    guard attachment.isLocalURL, let localURL = attachment._url else {
                        return attachment
                    }
                    let reference = Storage.storage().reference().child(category.rawValue).child(postID).child(attachment.id)
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    _ = try await reference.putFileAsync(from: localURL, metadata: metadata)
                    let url = try await reference.downloadURL()
                    return .init(url: url.absoluteString, type: .photo)
                }
            }
            var results = [XAttachment]()
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }

    static func sinitize(_ post: inout MutablePost, _ author: PersonInfo) throws {
        var keyWords = PostKeys.allCases.map { KeyWord.keyWord(for: $0, to: post)}.flatMap {$0}
        keyWords = keyWords
            .compactMap { $0 }
            .filter { $0.value != "Any" && $0.value != "0" && !$0.value.isWhitespace }.uniqued()
        post.keywords = keyWords.map { $0.keyValueString }.sorted()
    }
}
