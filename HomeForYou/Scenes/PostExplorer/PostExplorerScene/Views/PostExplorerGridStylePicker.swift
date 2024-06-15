//
//  GridStylePicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import SwiftUI

struct PostExplorerGridStylePicker: View {
    
    @EnvironmentObject private var gridAppearance: GridAppearance
    
    var body: some View {
        Picker("Grid Style", selection: $gridAppearance.gridStyle) {
            ForEach(GridStyle.allCases) { each in
                Image(systemName: each.iconName)
                    .tag(each)
            }
        }
        .pickerStyle(.segmented)
    }
}
