//
//  LazyLoadingImage.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import SwiftUI
import XUI

struct URLImage: View {
    
    private let imageLoader = ImageLoader()
    private let imageCDN = XImageCDN()
    @State private var image: UIImage?
    @State private var error: Error?
    
    let url: URL?
    var imageSize: ImageSize
    var onImageLoaded: ((UIImage) -> Void)?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let image {
                    imageView(for: image)
                } else if error != nil {
                    Color(uiColor: .placeholderText)
                } else {
                    Color.systemBackground
                    ProgressView()
                        .tint(Color.secondary)
                        .onAppear {
                            guard image == nil || url != nil else {
                                return
                            }
                            imageLoader.loadImage(
                                url: url,
                                imageCDN: imageCDN,
                                imageSize: imageSize,
                                completion: { result in
                                    DispatchQueue.safeAsync {
                                        switch result {
                                        case let .success(image):
                                            self.image = image
                                            onImageLoaded?(image)
                                        case let .failure(error):
                                            self.error = error
                                        }
                                    }
                                }
                            )
                        }
                }
            }
            .frame(size: geo.size)
        }
    }
    
    private func imageView(for image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
//            .if_let(onTap, { value, view in
//                view.onTapGesture {
//                    value(index ?? 0)
//                }
//            })
    }
}
