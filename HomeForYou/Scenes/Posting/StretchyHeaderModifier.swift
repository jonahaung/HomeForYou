//
//  BackgroundParallaxHeader.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/5/24.
//

import SwiftUI

private struct StretchyHeaderModifier<Header: View>: ViewModifier {
    @Binding var scrollViewOffset: CGFloat
    let height: CGFloat
    let multiplier: CGFloat
    let header: () -> Header
    
    init(
        _ scrollViewOffset: Binding<CGFloat>,
        height: CGFloat,
        multiplier: CGFloat = 1,
        @ViewBuilder header: @escaping () -> Header) {
            self._scrollViewOffset = scrollViewOffset
            self.height = height
            self.multiplier = multiplier
            self.header = header
        }
    
    func body(content: Content) -> some View {
        content.background(alignment: .top, content: {
            header()
                .offset(y: scrollViewOffset > 0 ? -scrollViewOffset * multiplier : 0)
                .scaleEffect(scrollViewOffset < 0 ? (height - scrollViewOffset) / height : 1, anchor: .top)
                .ignoresSafeArea()
        })
    }
}
public extension View {
    func stretchyHeader<Header: View>(
        _ scrollViewOffset: Binding<CGFloat>,
        height: CGFloat,
        multiplier: CGFloat = 1,
        @ViewBuilder header: @escaping () -> Header) -> some View {
            self.modifier(
                StretchyHeaderModifier(
                    scrollViewOffset,
                    height: height,
                    multiplier: multiplier,
                    header: header)
            )
        }
}
