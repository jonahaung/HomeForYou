//
//  PostTag.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/7/23.
//

import SwiftUI
import XUI

struct PostTag: View {

    let key: PostKey
    let value: String
    let isSelected: Bool
    var onTap: (() -> Void)?
    @Injected(\.ui) private var ui

    var body: some View {
        _Tag(color: ui.colors.opaqueSeparator) {
            HStack(alignment: .center, spacing: 1) {
                SystemImage(key.symbol)
                    .symbolRenderingMode(.hierarchical)
                Text(value)
            }
        }
        .font(.footnote.weight(.medium).width(.condensed))
        .fontDesign(.serif)
        .foregroundStyle(isSelected ? .secondary : .primary)
        .onTapGesture {
            _Haptics.play(.rigid)
            onTap?()
        }
    }
}
