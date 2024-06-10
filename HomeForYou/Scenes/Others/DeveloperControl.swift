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
            for post in lookings {
                group.addTask {
                    let post = post
                    post.description = Lorem.paragraph
                    try await Repo.shared.async_add(post)
                }
            }
        }
    }

    private func fetch() async {
        do {
            posts = try await Repo.shared.async_fetch(
                query: Firestore.firestore().collection(Category.rental_room.rawValue)
            )
            posts += try await Repo.shared.async_fetch(
                query: Firestore.firestore().collection(Category.rental_room.rawValue)
            )
            posts += try await Repo.shared.async_fetch(
                query: Firestore.firestore().collection(Category.selling.rawValue))
            lookings = try await Repo.shared.async_fetch(query: Firestore.firestore().collection(Looking.collectionPath)
            )
        } catch {
            Log(error)
        }
    }
}
