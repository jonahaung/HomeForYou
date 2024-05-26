//
//  DeepLinkView.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI
import XUI

struct DeepLinkButton<Content: View>: View {
    
    let screen: SceneItem
    @Injected(\.utils) private var utils
    @ViewBuilder var content: () -> Content

    @ViewBuilder
    var body: some View {
        if let url = utils.urlHandler.createURL(for: screen) {
            LinkButton(.url(url.absoluteString)) {
                content()
            }
        }
    }
}
