//
//  FilterTagsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/7/23.
//

import SwiftUI
import XUI

struct FilterTagsView: View {
    
    var filters: Binding<[PostFilter]>
    @Injected(\.ui) private var ui
    @State private var selection: String?
    
    var body: some View {
        VStack {
            WrappedVStack(alignment: .leading) {
                ForEach(filters.wrappedValue) { postFilter in
                    ForEach(postFilter.values, id: \.self) { each in
                        let isSelected: Bool = {
                            guard let selection else { return false }
                            return selection == each
                        }()
                        PostTag(key: postFilter.postKey, value: each, isSelected: isSelected, onTap: {
                            self.selection = isSelected ? nil : each
                        })
                        .overlay(alignment: .topTrailing) {
                            AsyncButton {
                                filters.forEach { filer in
                                    postFilter.values.forEach { each in
                                        if each == self.selection, let i = filters.wrappedValue.firstIndex(where: { $0 == postFilter }) {
                                            filters.wrappedValue.remove(at: i)
                                        }
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
        .animation(.interactiveSpring(), value: selection.str)
    }
}
