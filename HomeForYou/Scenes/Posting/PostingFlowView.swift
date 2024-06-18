//
//  PostCreaterView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/7/23.
//

import SwiftUI
import XUI
import SwiftyTheme

struct PostingFlowView<T: Postable>: View {
    
    @State private var post: T
    @Environment(\.dismiss) private var dismiss
    @StateObject private var postUploaderViewModel = PostUploaderViewModel()
    
    init(post: T) {
        self.post = post
    }
    
    var body: some View {
        PostForm_Address<MutablePost>(post.clone())
            .embeddedInNavigationView()
            .statusBarHidden(true)
            .ignoresSafeArea(.keyboard)
            .showLoading(postUploaderViewModel.loading)
            .alertPresenter($postUploaderViewModel.alert)
            .onRequestPostUpdate { action in
                await handleAaction(action)
            }
    }
    
    private func handleAaction(_ action: PostUpdateAction.ActionType) async {
        switch action {
        case .cancel:
            dismiss()
        case .upload(var postingData):
            await postUploaderViewModel.post(&postingData)
            self.post.copy(from: postingData)
            await MainActor.run {
                self.post.updateUI()
                dismiss()
            }
        case .update(var postingData):
            await postUploaderViewModel.post(&postingData)
            self.post.copy(from: postingData)
            await MainActor.run {
                self.post.updateUI()
                dismiss()
            }
        }
    }
}
