//
//  PostCreaterView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/7/23.
//

import SwiftUI
import XUI
import SwiftyTheme

struct PostingFlowView: View {
    
    let post: Post
    @State private var router = PostingFlowRouter()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack(path: $router.path) {
            PostForm_Address()
                .navigationDestination(for: PostingFlow.self) { flow in
                    switch flow {
                    case .attachments:
                        PostForm_Attachmments()
                    case .details:
                        PostForm_Details()
                    case .description:
                        PostForm_Description(dismiss: dismiss)
                    }
                }
        }
        .swiftyThemeStyle()
        .environment(router)
        .environmentObject(post)
        .statusBarHidden(true)
    }
}
