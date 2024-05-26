//
//  HomeCarousellView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/2/23.
//

import SwiftUI
import XUI

struct HomeCarousellSection: View {
    @Environment(AppConfigs.self) private var appConfigs
    var body: some View {
        InsetGroupSection(1) {
            TimerImageCroursellView(attachments: appConfigs.home_carousel_images)
                .frame(height: 220)
        }
    }
}
