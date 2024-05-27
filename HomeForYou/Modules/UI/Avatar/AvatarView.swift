//
//  CurrentUserAvatarView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/1/23.
//

import SwiftUI
import XUI
import URLImage

struct AvatarView: View {

    let urlString: String
    let size: CGFloat

    var body: some View {
        URLImage(url: .init(string: urlString), imageSize: .small)
            .frame(square: size)
            .clipShape(Circle())
    }
}
