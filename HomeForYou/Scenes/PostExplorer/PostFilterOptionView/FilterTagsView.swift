//
//  FilterTagsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/7/23.
//

import SwiftUI
import XUI

struct FilterTagsView: View {
    
    var queries: Binding<[PostQuery]>
    @Injected(\.ui) private var ui
    @State private var selection: PostQuery?
    
    var body: some View {
        WrappedVStack(alignment: .leading) {
            ForEach(queries.wrappedValue) { query in
                let isSelected: Bool = {
                    guard let selection else { return false }
                    return selection == query
                }()
                SelectablePostQueryTagView(key: query.key, value: query.value, isSelected: isSelected) {
                    self.selection = isSelected ? nil : query
                }
                .overlay(alignment: .topTrailing) {
                    AsyncButton {
                        queries.wrappedValue.forEach { query in
                            if query == self.selection, let i = queries.firstIndex(where: { $0.wrappedValue.key == query.key }) {
                                selection = nil
                                queries.wrappedValue.remove(at: i)
                            }
                        }
                    } label: {
                        SystemImage(.minusCircleFill)
                            .imageScale(.small)
                            .foregroundColor(.red)
                    }
                    .offset(x: 7, y: -7)
                    .buttonStyle(.plain)
                    ._hidable(!isSelected)
                }
            }
        }
    }
}
