//
//  PostListCellLarge.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/2/23.
//

import SwiftUI
import XUI
import SFSafeSymbols

struct PostSingleColumnLargeCell: View {
    
    let data: PostCellDisplayData
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils
    @Injected(\.router) private var router
    @State private var loadImage = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageCarousellView()
            VStack(alignment: .leading, spacing: 0) {
                content
//                HStack {
//                    Text(data.createdAt)
//                    Spacer()
//                    HStack(alignment: .center, spacing: 1) {
//                        SystemImage(.personCircleFill, 11)
//                        Text(data.post.author.name.str)
//                    }
//                }
//                .font(ui.fonts.caption1.italic())
//                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)
        }
        .padding(.bottom, 10)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .lastTextBaseline) {
                Text(data.price)
                    .font(.system(.title2, weight: .bold))
                Spacer()
                HStack {
                    ForEach(data.primaryTags, id: \.0) { each in
                        HStack(alignment: .center, spacing: 1) {
                            SystemImage(each.0.symbol, 12)
                            Text(each.1)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .font(ui.fonts.caption2.weight(.medium))
            }
            Text(data.title)
                .font(ui.fonts.subheadline.weight(.medium))
            
            HStack {
                ForEach(data.secondaryTags, id: \.0) { each in
                    HStack(alignment: .center, spacing: 1) {
                        SystemImage(each.0.symbol, 12)
                        Text(each.1)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                HStack(alignment: .center, spacing: 1) {
                    SystemImage(.personAndBackgroundDotted, 13)
                    Text(data.post.author.name.str)
                }
            }
            .font(ui.fonts.caption2.weight(.medium))
        }
        .symbolVariant(.fill)
    }
    private func imageCarousellView () -> some View {
        ZStack {
            Color.clear
            ImageCarousellView(attachments: data.post.attachments) { _ in
                DispatchQueue.main.async {
                    router.push(to: SceneItem(.postDetails, data: data.post))
                }
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    FavouriteButton()
                        .font(.title3)
                        .environmentObject(data.post)
                        .accentColor(Color.blue)
                    Spacer()
                }
            }
        }
        ._flexible(.horizontal)
        .aspectRatio(1.6, contentMode: .fill)
        .equatable(by: data.post.attachments)
    }
}
