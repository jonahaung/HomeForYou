//
//  SplashScreenView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/8/23.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            VStack {
                Spacer()
                LottieView(lottieFile: "building_sharp")
                Text("HOME FOR YOU")
                    .font(.title2.weight(.semibold))
                Spacer()
            }
        }
        .statusBarHidden(true)
    }
}
