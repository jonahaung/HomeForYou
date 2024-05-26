//
//  AnimationsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/7/23.
//

import SwiftUI

struct AnimationsView: View {
    var body: some View {
        List {
            Group {
                Group {
                    LottieView(lottieFile: "house_countryside")
                    LottieView(lottieFile: "home")
                    LottieView(lottieFile: "PinJump")

                    LottieView(lottieFile: "building2")
                    LottieView(lottieFile: "building3")
                    LottieView(lottieFile: "twitterHeart")
                    LottieView(lottieFile: "singaporemap")
                }
                Group {
                    LottieView(lottieFile: "home3")

                    LottieView(lottieFile: "bedroom")
                    LottieView(lottieFile: "landscape")
                    LottieView(lottieFile: "cityscape")
                    LottieView(lottieFile: "network")

                    LottieView(lottieFile: "building_sharp")
                    LottieView(lottieFile: "city_green")
                    LottieView(lottieFile: "city_bicycle", isJson: false)

                    LottieView(lottieFile: "dots", isJson: false)
                }
            }
            .frame(square: 200)
            .aspectRatio(1, contentMode: .fit)
            .listRowInsets(.init())
        }
    }
}
