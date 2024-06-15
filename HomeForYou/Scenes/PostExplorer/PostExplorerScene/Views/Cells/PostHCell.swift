//
//  PostHCell.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import SwiftUI

struct PostHCell: View {
    @EnvironmentObject private var post: Post
    var body: some View {
        VStack {
            PostCellImageView(post: post)
                .aspectRatio(1.5, contentMode: .fit)
                .routable(to: SceneItem(.postDetails, data: post))
        }
    }
}
