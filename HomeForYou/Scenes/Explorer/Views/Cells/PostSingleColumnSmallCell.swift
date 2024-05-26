//
//  PostRowCell.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import SwiftUI
import XUI

struct PostSingleColumnSmallCell: View {

    @EnvironmentObject private var post: Post
    @Injected(\.ui) private var ui

    var body: some View {
        HStack {
            imageView()
            VStack(alignment: .leading) {
                HStack {
                    Text("\(post.price)")
                        .font(ui.fonts.title2.bold().width(.compressed))
                    Spacer()
                    Group {
                        Text(post.propertyType.title)
                        if post.category == .rental_room {
                            Text(post._roomType.title)
                        }
                    }
                    .font(.caption.weight(.medium))

                    FavouriteButton()
                }
                Text(post.title)
                    .lineLimit(2)
                    .font(ui.fonts.subheadline.weight(.semibold))

                Text(post.getPostCaption())
                    .font(.footnote)
                    .foregroundStyle(.secondary.opacity(1))
            }
            ._flexible(.horizontal)
            .routable(to: SceneItem(.postDetails, data: post))
        }
    }

    private func imageView() -> some View {
        PostCellImageView(post: post)
            .aspectRatio(1, contentMode: .fill)
            .frame(maxWidth: 120, maxHeight: 120)
    }
}
