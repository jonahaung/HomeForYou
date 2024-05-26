//
//  ImageCroursellView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/2/23.
//

import SwiftUI
import NukeUI
import XUI
import SwiftyTheme

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
            URLImage(
                url: item._url,
                imageSize: .medium
            )
        }
        .onTapGesture {
            if let onTap {
                onTap(selection)
            } else {
                tappedIndex = selection
            }
        }
        .fullScreenCover(item: $tappedIndex) { _ in
            PhotoGalleryView(attachments: attachments, title: "Gallery", selection: $selection)
                .swiftyThemeStyle()
        }
        .equatable(by: attachments)
    }
}
