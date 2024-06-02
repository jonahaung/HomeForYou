//
//  WaterfallImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 29/6/23.
//

import SwiftUI
import URLImage

struct WaterfallImage: View {
    let urlString: String?
    @State private var aspectRatio = CGFloat(1)
    var body: some View {
        URLImage(url: .init(string: urlString.str), imageSize: .medium) { image in
            aspectRatio = image.size.width / image.size.height
        }
        .aspectRatio(aspectRatio, contentMode: .fill)
    }
}
