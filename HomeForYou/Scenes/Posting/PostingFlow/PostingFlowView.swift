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

struct PostingFlowView: View {
    
    private let post: Post
    @State private var postingData: MutablePost
    @State private var router = PostingFlowRouter()
    @Environment(\.dismiss) private var dismiss
    
    init(post: Post) {
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
                        PostForm_Description(dismiss: dismiss, postingData: $postingData)
                    }
                }
        }
        .swiftyThemeStyle()
        .environment(router)
        .statusBarHidden(true)
    }
}
