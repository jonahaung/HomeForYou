//
//  SearchingView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/24.
//

import SwiftUI
import XUI

private struct SearchableViewModifier: ViewModifier {
    @StateObject var datasource: SearchDatasource
    @Environment(\.onSearchAction) private var onSearchAction
    func body(content: Content) -> some View {
        content
            .onAppear {
                datasource.onAppear()
            }
            .onDisappear {
                datasource.onDisAppear()
            }
            .overlay(alignment: .top) {
                SearchResultsView()
                    .environmentObject(datasource)
                
            }
            .searchable(
                text: $datasource.searchText,
                tokens: $datasource.tokens,
                isPresented: $datasource.isPresented,
                placement: .navigationBarDrawer(
                    displayMode: .automatic
                ),
                prompt: "Search Posts"
            ) { token in
                Text(token.value.title)
            }
            .searchPresentationToolbarBehavior(.automatic)
            .searchScopes(
                $datasource.searchScope,
                activation: .onSearchPresentation
            ) {
                ForEach(Search.Scope.allCases) { each in
                    Text(each.rawValue)
                        .tag(each)
                }
            }
            .onSubmit(of: .search) {
                let filter = datasource.tokens
                datasource.canPresentOnAppear = true
                Task {
                    await onSearchAction?(.filter(filter.map{ PostQuery($0.key, $0.value)}))
                }
            }
            .disableAutocorrection(true)
            .textInputAutocapitalization(.words)
    }
}

extension View {
    func makeSearchable(_ datasource: SearchDatasource) -> some View {
        modifier(SearchableViewModifier(datasource: datasource))
    }
}
