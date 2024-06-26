//
//  PostDetailsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/3/23.
//

import SwiftUI
import XUI
import FireAuthManager

struct PostDetailsView: View {
    
    @EnvironmentObject private var post: Post
    @Injected(\.utils) private var utils
    @Injected(\.currentUser) private var currentUser
    @Injected(\.router) private var router
    
    var body: some View {
        List {
            PostDetailsSections.AttachmentSection()
            PostDetailsSections.TitleOverviewSection()
            PostDetailsSections.DescriptionSection()
            PostDetailsSections.OtherDetailsSection()
            PostDetailsSections.AddressSection()
            PostDetailsSections.FeaturesAndRestrictionsSection()
            PostDetailsSections.AuthorSection()
            PostDetailsSections.KeyWordsSection()
            PostDetailsSections.ViewsAndFavouritesSection()
            PostDetailsSections.ActionSection()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(
                placement: .navigationBarTrailing
            ) {
                if let url = utils.urlHandler.createURL(
                    for: SceneItem(
                        .postDetails,
                        data: post
                    )
                ) {
                    ShareLink(
                        item: url
                    )
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            PostDetailsSections.PostDetailsContactsToolbar()
        }
        .task(id: post, priority: .background) {
            await updateHasSeenIfNeeded(post)
        }
        .magicButton(.constant(
            .init(isCurrentUser ? .init(rawValue: "pencil.and.scribble") : .arrowshapeLeftFill, isCurrentUser ? .bottomTrailing : .bottomLeading) {
                if isCurrentUser {
                    router.presentFullScreen(SceneItem(.createPost, data: post))
                } else {
                    router.currentNavRouter?.pop()
                }
            }
        ))
    }
    private var isCurrentUser: Bool {
        post.author.id == currentUser.uid
    }
    private func updateHasSeenIfNeeded(_ post: Post) async {
        guard currentUser.isLoggedIn else { return }
        
        if !post.views.contains(currentUser.uid) {
            post.views.append(currentUser.uid)
            try? await Repo.shared.async_update(path: post.category.rawValue, for: post.id, in: Post.self, data: [.views: post.views])
        }
    }
}
