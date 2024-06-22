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
    
    private let keywordsFactiory = KeywordsFactory()
    @Injected(\.currentUser) private var currentUser
    
    func post<T: Postable>(_ post: inout T) async throws {
        guard let model = currentUser.model else { throw XError.user_not_logged_in  }
        guard !post.attachments.isEmpty else {
            throw XError.attachments_isEmpty
        }
        post.author = model.personInfo
        let keywords = keywordsFactiory.keywords(for: post)
        post.keywords = keywords.map{ $0.keyValueString }
        let attachments = try await upload(attachments: post.attachments, postID: post.id, category: post.category)
        post.attachments = attachments
        
        try await Repo.shared.async_add(post, false)
    }
    
    private func upload(attachments: [XAttachment], postID: String, category: Category) async throws -> [XAttachment] {
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
}
