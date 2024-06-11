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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            imageCarousellView()
            VStack(alignment: .leading, spacing: 0) {
                content
                HStack {
                    Text(data.createdAt)
                    Spacer()
                    Text(data.post.author.name.str)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }.padding(.horizontal, 16)
        }
        .padding(.bottom)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(data.price)
                    .font(.system(.title3, weight: .bold))
                Spacer()
                HStack {
                    ForEach(data.primaryTags, id: \.0) {
                        Text("\(Image(systemSymbol: $0.0.symbol))\($0.1.title)")
                    }
                }
                .font(ui.fonts.footnote)
                .foregroundStyle(.secondary)
            }
            Text(data.title)
            
            HStack {
                ForEach(data.secondaryTags, id: \.0) {
                    Text("\(Image(systemSymbol: $0.0.symbol))\($0.1.title)")
                }
            }
            .font(ui.fonts.footnote)
            .foregroundStyle(.secondary)
        }
    }
    private func imageCarousellView () -> some View {
        ZStack {
            ImageCarousellView(attachments: data.post.attachments) { _ in
                DispatchQueue.main.async {
                    router.push(to: SceneItem(.postDetails, data: data.post))
                }
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    FavouriteButton()
                        .font(.title3)
                        .tint(.white)
                        .environmentObject(data.post)
                }
            }
        }
        .aspectRatio(1.6, contentMode: .fill)
    }
}
