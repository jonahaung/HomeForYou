//
//  FeatureTagView.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI
import XUI

struct SelectableTag: View {
    
    let title: String
    @Binding var isSelected: Bool
    @Injected(\.ui) private var ui
    
    var body: some View {
        _Tag(color: isSelected ? .secondary : ui.colors.tertiaryLabel) {
            Text(title)
        }
        .font(ui.fonts.footnote.lowercaseSmallCaps())
        .fontDesign(.serif)
        .foregroundStyle(isSelected ? .primary : .tertiary)
        .onTapGesture {
            isSelected.toggle()
            _Haptics.play(.rigid)
        }
    }
}
