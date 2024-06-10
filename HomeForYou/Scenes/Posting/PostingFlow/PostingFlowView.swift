//
//  PostCreaterView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/7/23.
//

import SwiftUI
import XUI
import SwiftyTheme
import FireAuthManager
import FirebaseAuth

struct PostingFlowView<T: Postable>: View {
    
    @State private var post: T
    @State private var postingData: MutablePost
    @State private var router = PostingFlowRouter()
    @Injected(\.currentUser) private var currentUser
    @Environment(\.dismiss) private var dismiss
    
    init(post: T) {
        self.post = post
        self.postingData = post.clone()
    }
    var body: some View {
        NavigationStack(path: $router.path) {
            PostForm_Address($postingData._location)
                .navigationDestination(for: PostingFlow.self) { flow in
                    switch flow {
                    case .attachments:
                        PostForm_Attachmments(post: $postingData)
                    case .details:
                        PostForm_Details(postingData: $postingData)
                    case .description:
                        PostForm_Description(postingData: $postingData)
                    }
                }
        }
        .swiftyThemeStyle()
        .environment(router)
        .statusBarHidden(true)
        .onTakePostingAction { action in
            switch action {
            case .cancel:
                dismiss()
            case .upload(let post):
                if let model = currentUser.model {
                    var mutablePost = post
                    do {
                        try await PostUploader.post(&mutablePost, author: PersonInfo(model: model))
                        self.post.copy(from: mutablePost)
                        await MainActor.run {
                            self.post.updateUI()
                            dismiss()
                        }
                    } catch {
                        Log(error)
                    }
                }
            case .update(let post):
                if let model = currentUser.model {
                    var mutablePost = post
                    do {
                        try await PostUploader.post(&mutablePost, author: PersonInfo(model: model))
                        self.post.copy(from: mutablePost)
                        await MainActor.run {
                            self.post.updateUI()
                            dismiss()
                        }
                    } catch {
                        Log(error)
                    }
                }
            }
        }
    }
}
