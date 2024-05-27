//
//  TimerImageCroursellView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/6/23.
//

import SwiftUI
import XUI
import SwiftyTheme
import URLImage

struct TimerImageCroursellView: View {
    
    @State var attachments: [XAttachment]
    @State private var selection = 0
    @State private var scrollId: Int?
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var direction: Int = 1
    @State private var tappedIndex: Int?
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollViewWithOffsetTracker(.horizontal, showsIndicators: false) { offset in
                    let factor = CGFloat(attachments.count)
                    let totalWidth = geometry.size.width * factor
                    let floatValue = abs(offset.x) * factor/totalWidth
                    let intValue = Int(floatValue)
                    if floatValue == CGFloat(intValue) {
                        scrollId = intValue
                    }
                } content: {
                    LazyHStack(spacing: 0) {
                        ForEach(Array(attachments.enumerated()), id: \.element.id) { (i, each) in
                            URLImage(
                                url: each._url,
                                imageSize: .medium
                            )
                            .containerRelativeFrame([.horizontal, .vertical])
                            .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive, transition: { view, phase in
                                view
                                    .scaleEffect(1-(phase.value < 0 ? -phase.value/2 : phase.value/2), anchor: phase.value < 0 ? .trailing : .leading)
                            })
                            .id(i)
                        }
                    }
                    .onTapGesture {
                        tappedIndex = selection
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $scrollId, anchor: .center)
                .animation(.linear(duration: 0.8), value: scrollId)
            }
            XPhotoPageControl(selection: $selection, length: attachments.count, size: 10.scaled)
                .foregroundStyle(.secondary)
        }
        .fullScreenCover(item: $tappedIndex) { _ in
            PhotoGalleryView(attachments: attachments, title: "Gallery", selection: $selection)
                .swiftyThemeStyle()
        }
        .onChange(of: selection) { _, newValue in
            if scrollId != newValue {
                scrollId = newValue
            }
        }
        .onChange(of: scrollId) { oldValue, newValue in
            invalidateTimer()
            if let newValue, selection != newValue {
                selection = newValue
            }
        }
        .onReceive(timer) { _ in
            let total = sources.count
            guard total > 1 else { return }
            direction = selection == 0 ? 1 : ( selection == total-1 ? -1 : direction )
            selection += direction
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onAppear {
            invalidateTimer()
        }
    }
    
    private func invalidateTimer(_ t: Int = Int.random(in: 3...7)) {
        timer.upstream.connect().cancel()
        timer = Timer.publish(every: TimeInterval(t), on: .main, in: .common).autoconnect()
    }
    private var sources: [URL] {
        attachments.compactMap { attachment in
            URL(string: attachment.url)
        }
    }
}
