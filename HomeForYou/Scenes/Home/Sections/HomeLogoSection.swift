//
//  HomeLogoSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI

struct HomeLogoSection: View {
    
    private let lottieView: some View = LottieView(lottieFile: "landscape")
        .aspectRatio(1.2, contentMode: .fill)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            lottieView
                .equatable(by: 0)
            Text("Home for you")
                .font(Font.title2.weight(.semibold).lowercaseSmallCaps())
                .foregroundColor(.primary)
        }
    }
}
