//
//  SearchingView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/24.
//

import SwiftUI
import SwiftyTheme

struct SearchingView: View {
    
    @State private var viewModel = SearchingViewModel()
    @State private var presented = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            SearchResultsView()
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $viewModel.searchText, tokens: $viewModel.selectedTokens, isPresented: $presented, token: { token in
                    Text(token.value)
                })
                .autocorrectionDisabled(true)
                .onSubmit(of: .search) {
                    presented = false
                    viewModel.onSubmitSearch()
                }
                .environment(viewModel)
        }
        .swiftyThemeStyle()
        .onChange(of: presented) { oldValue, newValue in
            if !newValue {
                dismiss()
            }
        }
    }
}
