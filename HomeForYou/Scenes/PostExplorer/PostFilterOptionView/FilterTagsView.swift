//
//  FilterTagsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/7/23.
//

import SwiftUI
import XUI

struct FilterTagsView: View {
    
    @Binding var query: CompoundQuery
    @Injected(\.ui) private var ui
    @State private var selection: PostQuery?
    
    var body: some View {
        WrappedVStack(alignment: .leading) {
            switch query {
            case .exactMatch(var queries):
                ForEach(queries) { query in
                    let isSelected: Bool = {
                        guard let selection else { return false }
                        return selection == query
                    }()
                    SelectablePostQueryTagView(key: query.key, value: query.value, isSelected: isSelected) {
                        self.selection = isSelected ? nil : query
                    }
                    .overlay(alignment: .topTrailing) {
                        AsyncButton {
                            queries.forEach { query in
                                if query == self.selection, let i = queries.firstIndex(where: { $0.key == query.key }) {
                                    selection = nil
                                    queries.remove(at: i)
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
            case .keywords(var keywords):
                ForEach(keywords) { keyword in
                    let query = PostQuery(keyword.key, keyword.value)
                    let isSelected: Bool = {
                        guard let selection else { return false }
                        return selection == query
                    }()
                    SelectablePostQueryTagView(key: query.key, value: query.value, isSelected: isSelected) {
                        self.selection = isSelected ? nil : query
                    }
                    .overlay(alignment: .topTrailing) {
                        AsyncButton {
                            keywords.forEach { keyword in
                                let query = PostQuery(keyword.key, keyword.value)
                                if query == self.selection, let i = keywords.firstIndex(where: { $0.key == query.key }) {
                                    selection = nil
                                    keywords.remove(at: i)
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
            case .priceRange(let priceRange):
                let postQuery = PostQuery(.price, "\(priceRange.range.lowerBound)-\(priceRange.range.upperBound)")
                let isSelected = selection == postQuery
                SelectablePostQueryTagView(key: postQuery.key, value: postQuery.value, isSelected: isSelected) {
                    selection = selection == postQuery ? nil : postQuery
                }

            }
        }
    }
}
