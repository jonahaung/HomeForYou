//
//  MRTListPickerBar.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 31/3/24.
//

import SwiftUI
import XUI

struct MRTListPickerBar: View {

    @Binding var selections: [MRT]
    let allowMultiple: Bool

    var body: some View {
        HStack {
            Text("MRT Station\(allowMultiple ? "s" : "")")
                .foregroundStyle(selections.isEmpty ? .primary : .secondary)
            Spacer()
            Group {
                Color.clear
                if let mrt = selections.first {
                    HStack(spacing: 0) {
                        Text(mrt.name)
                        if selections.count > 1 {
                            Text(" +\(selections.count-1)")
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }.fixedSize()
                }
            }
            ._tapToPush {
                MRTPickerView(selections: $selections, allowMultiple: allowMultiple)
            }
        }
    }
}
