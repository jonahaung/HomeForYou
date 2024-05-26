//
//  DeveloperControl.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/5/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import XUI

struct DeveloperControl: View {

    @State private var posts = [Post]()
    @State private var lookings = [Looking]()

    var body: some View {
        Form {
            Text(posts.count.description)
            Text(lookings.count.description)
            AsyncButton {
                await takeAction()
            } label: {
                Text("Take Action")
                    ._borderedProminentButtonStyle()
            }
        }
        .navigationTitle("Developer Controls")
        .task {
            await fetch()
        }
    }

    private func takeAction() async {
        await withThrowingTaskGroup(of: Void.self) { group in
            for post in posts {
                group.addTask {
                    let post = post
                    var urls = [URL]()
                    (3...6).forEach { _ in
                        urls.append(DemoImages.demoPhotosURLs.random()!)
                    }
                    post.attachments = urls.map { .init(url: $0.absoluteString, type: .photo)}
                    post._location.geoInfo.geoHash = post._location.geoInfo.coordinate.geohash(length: 6)
                    try await Repo.async_add(post)
                }
            }

        }
    }

    private func fetch() async {
        do {
            posts = try await Repo.async_fetch(
                query: Firestore.firestore().collection(Category.rental_room.rawValue)
            )
            posts += try await Repo.async_fetch(
                query: Firestore.firestore().collection(Category.rental_room.rawValue)
            )
            posts += try await Repo.async_fetch(
                query: Firestore.firestore().collection(Category.selling.rawValue))
            lookings = try await Repo.async_fetch(query: Firestore.firestore().collection(Looking.collectionPath)
            )
        } catch {
            print(error)
        }
    }
}
