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
    @Injected(\.currentUser) private var currentUser
    @Environment(\.dismiss) private var dismiss
    
    init(post: T) {
        self.post = post
    }
    
    var body: some View {
        PostForm_Address<MutablePost>(post.clone())
            .embeddedInNavigationView()
            .statusBarHidden(true)
            .onTakePostingAction { action in
                await handleAaction(action)
                
            }
    }
    
    private func handleAaction(_ action: PostingAction.ActionType) async {
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
