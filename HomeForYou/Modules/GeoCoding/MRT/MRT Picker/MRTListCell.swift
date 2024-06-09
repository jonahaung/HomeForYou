//
//  MRTCell.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 31/3/24.
//

import SwiftUI
import XUI

struct MRTListCell: View {
    
    let mrt: MRT
    @Binding var isSelected: Bool
    @Injected(\.ui) private var ui
    var body: some View {
        HStack {
            SystemImage(isSelected ? .checkmark : .circle)
                .symbolVariant(isSelected ? .circle.fill : .none)
                .foregroundColor(isSelected ? .green : ui.colors.quaternaryLabel)
                .imageScale(.large)

            AsyncButton(actionOptions: [.disableButton]) {
                isSelected.toggle()
            } label: {
                Cell(mrt: mrt)
            }
            .buttonStyle(.borderless)
        }
    }
    
    private struct Cell: View {
        let mrt: MRT
        var body: some View {
            HStack {
                Text(mrt.name)
                    .foregroundStyle(Color.primary)
                Spacer()
                HStack(spacing: 1) {
                    ForEach(mrt.symbol) {
                        Text($0.code)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 1)
                            .background($0.swiftColor ?? .accentColor, in: Capsule())
                    }
                }
                .foregroundStyle(Color.white)
                .font(.caption2)
            }
        }
    }
}
