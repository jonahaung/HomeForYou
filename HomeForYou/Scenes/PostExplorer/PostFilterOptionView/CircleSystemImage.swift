//
//  CircleSystemImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/6/24.
//

import SwiftUI
import XUI
import SFSafeSymbols

public struct CircleSystemImage<Background: View>: View {
    
    private let icon: SFSymbol
    private let background: Background
    
    public init(_ icon: SFSymbol, _ background: Background) {
        self.icon = icon
        self.background = background
    }
    
    public var body: some View {
        SystemImage(icon, 18)
            .imageScale(.small)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(Color(uiColor: .systemBackground))
            .padding(6)
            .background {
                background
                    .opacity(0.8)
                    .clipShape(.containerRelative)
            }
            .background(.fill.tertiary)
            .containerShape(.circle)
            .compositingGroup()
            .symbolVariant(.fill)
    }
}
