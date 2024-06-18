//
//  ImageCroursellView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/2/23.
//

import SwiftUI
import XUI
import URLImage

public struct ImageCarousellView: View {
    
    private let attachments: [XAttachment]
    private var onTap: ((Int) -> Void)?
    @State private var selection = 0
    @State private var tappedIndex: Int?
    
    public init(attachments: [XAttachment], onTap: ( (Int) -> Void)? = nil) {
        self.attachments = attachments
        self.onTap = onTap
    }
    
    public var body: some View {
        PagerScrollView(attachments, id: \.id, selection: $selection) { item in
            URLImage(url: item._url) { state in
                switch state {
                case .empty:
                    ProgressView()
                        .foregroundStyle(Color.secondary)
                case .success(let image, _):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo.fill")
                        .imageScale(.large)
                        .blendMode(.overlay)
                }
            }
            .containerRelativeFrame([.horizontal, .vertical])
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive, transition: { view, phase in
                view
                    .scaleEffect(1-(phase.value < 0 ? -phase.value/2 : phase.value/2), anchor: phase.value < 0 ? .trailing : .leading)
            })
            .id(item)
            .equatable(by: item._url)
        }
        .onTapGesture {
            _Haptics.play(.soft)
            if let onTap {
                onTap(selection)
            } else {
                tappedIndex = selection
            }
        }
        .if (onTap == nil) { view in
            view
                .fullScreenCover(item: $tappedIndex) { _ in
                    PhotoGalleryView(attachments: attachments, title: "Gallery", selection: $selection)
                        .swiftyThemeStyle()
                }
        }
    }
}
