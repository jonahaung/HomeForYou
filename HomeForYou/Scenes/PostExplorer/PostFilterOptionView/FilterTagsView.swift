//
//  FilterTagsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/7/23.
//

import SwiftUI
import XUI

struct FilterTagsView: View {
    
    @Binding var items: [PostQuery]
    @Injected(\.ui) private var ui
    @State private var selection: PostQuery?
    
    var body: some View {
        WrappedVStack(alignment: .leading) {
            ForEach(items) { query in
                let isSelected: Bool = {
                    guard let selection else { return false }
                    return selection == query
                }()
                SelectablePostQueryTagView(key: query.key, value: query.value, isSelected: isSelected) {
                    self.selection = isSelected ? nil : query
                }
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        AsyncButton {
                            items.forEach { each in
                                if each == self.selection, let i = items.firstIndex(where: { $0 == each }) {
                                    selection = nil
                                    items.remove(at: i)
                                }
                            }
                        } label: {
                            SystemImage(.xmarkCircleFill)
                                .symbolRenderingMode(.multicolor)
                                .padding(.leading)
                        }
                        .offset(x: 7, y: -7)
                        .zIndex(5)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.1, anchor: .center),
                                removal: .scale(scale: 0.1, anchor: .center)
                            )
                            .animation(.easeInOut)
                        )
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 0.1, anchor: .leading),
                        removal: .scale(scale: 0.1, anchor: .leading)
                    )
                    .animation(.easeInOut)
                )
            }
        }
    }
}
