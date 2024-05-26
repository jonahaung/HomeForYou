//
//  SearchResultsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/8/23.
//

import SwiftUI

struct SearchResultsView: View {
    
    @Environment(SearchingViewModel.self) private var viewModel
    
    var body: some View {
        List {
            ForEach(viewModel.responses) { each in
                Button {
                    viewModel.onSubmitSearch(each.keyword)
                } label: {
                    HStack {
                        Text(each.attributedString)
                            .lineLimit(1)
                        Spacer()
                        Text("\(Image(systemSymbol: each.keyword.key.symbol))")
                            .fixedSize()
                            .foregroundStyle(.tertiary)
                    }.background()
                }
                .tint(Color.primary)
                .buttonStyle(.borderless)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
