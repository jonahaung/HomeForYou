//
//  TextIconRow.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/7/23.
//

import SwiftUI
import SFSafeSymbols
import XUI

public struct ListRowLabel: View {

    private let alignment: HorizontalAlignment
    private let icon: SFSymbol?
    private let text: String
    @Injected(\.ui) private var ui

    public init(alignment: HorizontalAlignment = .listRowSeparatorLeading, _ icon: SFSymbol?, _ text: String) {
        self.alignment = alignment
        self.icon = icon
        self.text = text
    }

    private func image(_ icon: SFSymbol) -> some View {
        SystemImage(icon, 18)
            .imageScale(.small)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(Color(uiColor: .systemBackground))
            .padding(6)
            .background {
                LinearGradient(
                    colors: [Color.random(seed: icon.rawValue), Color.gray, Color.random(seed: icon.rawValue)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(0.8)
                .clipShape(.containerRelative)
            }
            .background(.fill.tertiary)
            .containerShape(.circle)
            .compositingGroup()
            .symbolVariant(.fill)
    }

    private func text(_ text: String) -> some View {
        Text(.init(text))
            .fixedSize()
            .font(ui.fonts.callOut)
            .foregroundStyle(Color.primary)
    }

    public var body: some View {
        HStack(spacing: 16) {
            switch alignment {
            case .center:
                Color.clear
                if let icon {
                    image(icon)
                }
                text(text)
                Color.clear
            case .leading:
                if let icon {
                    image(icon)
                }
                text(text)
                Color.clear
            case .trailing:
                Color.clear
                if let icon {
                    image(icon)
                }
                text(text)
            default:
                if let icon {
                    image(icon)
                }
                text(text)
            }
        }
    }
}
