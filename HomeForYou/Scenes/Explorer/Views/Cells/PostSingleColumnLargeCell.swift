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
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("$\(utils.kmbFormatter.string(fromNumber: post.price))")
                    .font(.system(.title3, weight: .bold))
                Spacer()
                HStack {
                    Text("\(Image(systemName: SFSymbol.buildingFill.rawValue))\(post.propertyType.title)")
                    
                    Text("\(Image(systemName: SFSymbol.windowAwningClosed.rawValue))\(post._roomType.title)")
                    
                    Text("\(Image(systemName: SFSymbol.bedDoubleFill.rawValue))\(post.beds.title)")
                    
                    Text("\(Image(systemName: SFSymbol.showerFill.rawValue))\(post.baths.title)")
                }
                .font(ui.fonts.footnote)
                .foregroundStyle(.secondary)
            }
            Text(post.title)
                .font(ui.fonts.subheadline.weight(.medium))
            HStack {
                Text("\(Image(systemName: SFSymbol.mappin.rawValue))\(post.area.title) ")
                Text("\(Image(systemName: SFSymbol.tram.rawValue))\(post.mrt) (\(post.mrtDistance) mins)")
            }
            .font(ui.fonts.footnote)
            .foregroundStyle(.secondary)
        }
    }
    private func imageCarousellView () -> some View {
        ZStack {
            Color.secondary
            ImageCarousellView(attachments: post.attachments) { _ in
                DispatchQueue.main.async {
                    router.push(to: SceneItem(.postDetails, data: post))
                }
            }
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
