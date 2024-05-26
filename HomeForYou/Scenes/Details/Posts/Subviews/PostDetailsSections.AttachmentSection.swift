//
//  AttachmentSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 4/8/23.
//

import SwiftUI
import XUI

extension PostDetailsSections {
    // Attachment
    struct AttachmentSection: View {
        @EnvironmentObject private var post: Post
        var body: some View {
            Section {
                ImageCarousellView(attachments: post.attachments)
                    .frame(height: 250)
            } footer: {
                HStack {
                    _Label(spacing: 1) {
                        SystemImage(.handThumbsupCircle)
                    } right: {
                        Text(post.favourites.count.description)
                    }
                    _Label(spacing: 1) {
                        SystemImage(.eyeCircleFill)
                    } right: {
                        Text(post.views.count.description)
                    }

                    Spacer()

                    FavouriteButton()
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .listRowInsets(.init())
            .listRowBackground(EmptyView())
        }
    }
}
