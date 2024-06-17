//
//  WaterfallImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 29/6/23.
//

import SwiftUI
import XUI
import URLImage

struct WaterfallImage: View {
    let urlString: String?
    @State private var aspectRatio = CGFloat(1)
    var body: some View {
        URLImage(url: URL(string: urlString.str), transaction: .init(animation: .bouncy)) { state in
          switch state {
          case .empty:
            ProgressView()
          case .success(let image, let size):
              let aspectRatio = size.width/size.height
            image
                  .resizable()
                  .scaledToFill()
                  .aspectRatio(aspectRatio, contentMode: .fill)
                  .onAppear {
                      self.aspectRatio = aspectRatio
                  }
          case .failure:
            Image(systemName: "photo.fill")
              .imageScale(.large)
              .blendMode(.overlay)
          }
        }
        .aspectRatio(aspectRatio, contentMode: .fill)
        .background(Color.secondary.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
