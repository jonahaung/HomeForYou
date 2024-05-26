//
//  WaterfallImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 29/6/23.
//

import SwiftUI
import XUI
import NukeUI

struct WaterfallImage: View {

    let urlString: String?
    private let imageLoader = ImageLoader()
    private let imageCDN = XImageCDN()
    @State private var result: Result<UIImage, Error>?

    var body: some View {
        ZStack {
            if let result {
                switch result {
                case .success(let success):
                    Image(uiImage: success)
                        .resizable()
                        .scaledToFit()
                case .failure(let failure):
                    Text(failure.localizedDescription)
                        .font(.footnote)
                        .italic()
                        .foregroundColor(.secondary)
                }
            } else {
                Color.clear
            }
        }
        .task {
            guard result == nil else { return }
            imageLoader
                .loadImage(url: URL(string: urlString ?? ""), imageCDN: imageCDN, imageSize: .medium) { result in
                    self.result = result
                }
        }
    }
}
