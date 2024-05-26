//
//  PostSquareCell.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import SwiftUI
import XUI

struct PostDoubleColumnCell: View {

    @EnvironmentObject private var post: Post
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageView()
            HStack(spacing: 2) {
                Text(utils.kmbFormatter.string(fromNumber: post.price))
                    .font(ui.fonts.title3.bold().width(.condensed))
                Text(post.title)
                    .foregroundStyle(.secondary)
                    .font(ui.fonts.footnote.weight(.medium).width(.condensed))
                    .lineLimit(1)
            }
            .padding(.bottom, 4)
        }
    }

    private func imageView() -> some View {
        PostCellImageView(post: post)
            .aspectRatio(0.8, contentMode: .fill)
            .overlay {
                VStack {
                    HStack(spacing: 1) {
                        Group {
                            Text(post.propertyType.title)
                            if post.category == .rental_room {
                                Text(post._roomType.title)
                            }
                        }
                        .padding(.horizontal, 4)
                        .font(ui.fonts.caption1)
                        .background(Color.secondary)
                        .foregroundColor(ui.colors.backgroundColor)
                        Spacer()
                        if let url = post.author.photoURL {
                            AvatarView(urlString: url, size: 25)
                        }
                    }
                    Spacer()
                    HStack {
                        Text(post.area.title)
                            .padding(.horizontal, 4)
                            .background(Color.secondary)
                            .font(ui.fonts.caption1.italic())
                            .foregroundColor(ui.colors.backgroundColor)

                        Spacer()
                    }
                }
                .padding(3)
                .routable(to: SceneItem(.postDetails, data: post))
            }
    }
}
