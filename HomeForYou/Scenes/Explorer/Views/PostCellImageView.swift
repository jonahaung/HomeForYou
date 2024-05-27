//
//  PostCellImageView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/2/23.
//

import SwiftUI
import URLImage

struct PostCellImageView: View {
    let post: Post
    var body: some View {
        URLImage(url: post.attachments.first?._url, imageSize: .medium)
            .clipped()
    }
}
