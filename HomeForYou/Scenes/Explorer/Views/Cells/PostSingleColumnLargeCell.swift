//
//  PostListCellLarge.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/2/23.
//

import SwiftUI
import XUI
import SFSafeSymbols
import NukeUI
import Nuke

struct PostSingleColumnLargeCell: View {

    @EnvironmentObject private var post: Post
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils
    @Injected(\.router) private var router

    var body: some View {
        InsetGroupSection(4) {
            VStack(alignment: .leading, spacing: 0) {
                imageCarousellView()
                content
                    .padding(.horizontal, 5)
            }
            .padding(.bottom, 8)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
        } footer: {
            HStack {
                Text("\(utils.timeAgoFormatter.string(from: post.createdAt)) ago")
                Spacer()
                Text(post.author.name ?? post.author.email ?? "")
            }
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("\(post.price)")
                    .font(.system(.title3, weight: .bold))
                Spacer()
                Group {
                    Text("\(Image(systemName: SFSymbol.building2CropCircle.rawValue))\(post.propertyType.title) ")
                    +
                    Text("\(Image(systemName: SFSymbol.windSnowCircle.rawValue))\(post.roomType?.title ?? "") ")
                    +
                    Text("\(Image(systemName: SFSymbol.bedDoubleCircle.rawValue))\(post.beds.title) ")
                    +
                    Text("\(Image(systemName: SFSymbol.toiletCircle.rawValue))\(post.baths.title) ")
                }
                .font(ui.fonts.caption1)
                .foregroundStyle(.secondary)
            }

            Text(post.title)
                .lineLimit(2)
                .font(ui.fonts.subheadline.weight(.medium))

            Group {
                Text("\(Image(systemName: SFSymbol.mappinCircle.rawValue))\(post.area.title) ")
                +
                Text("\(Image(systemName: SFSymbol.tramCircle.rawValue))\(post.mrt) ")
                +
                Text("(\(post.mrtDistance) mins)").italic()
            }
            .font(ui.fonts.caption1)
            .foregroundStyle(.secondary)
        }
    }
    private func imageCarousellView () -> some View {
        ZStack {
            ImageCarousellView(attachments: post.attachments, onTap: { _ in
                DispatchQueue.main.async {
                    router.push(to: SceneItem(.postDetails, data: post))
                }
            })
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    FavouriteButton()
                        .font(.title3)
                        .tint(.white)
                }
            }
            ._flexible(.all)
        }
        .aspectRatio(1.6, contentMode: .fill)
    }
}
