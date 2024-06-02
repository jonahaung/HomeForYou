//
//  SearchResultsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/8/23.
//

import SwiftUI
import XUI

struct SearchResultsView: View {
    
    @EnvironmentObject private var datasource: SearchDatasource
    @Injected(\.router) private var router
    
    var body: some View {
        if datasource.isPresented {
            List {
                switch datasource.result {
                case .suggestions:
                    Section {
                        AsyncButton {
                            
                        } label: {
                            Label("Use my current location", systemSymbol: .location)
                        }
                        AsyncButton {
                            
                        } label: {
                            Label("Set location on map", systemSymbol: .mappinAndEllipse)
                        }
                        AsyncButton {
                            
                        } label: {
                            Label("Select from MRT map", systemSymbol: .mappinSquare)
                        }
                    } header: {
                        Text("Advanced searches")
                    }
                    Section {
                        AsyncButton {
                            datasource.canPresentOnAppear = true
                            router.push(to: .init(.postCollection, data: [] as [PostFilter]))
                        } label: {
                            HStack {
                                Label("Explore all posts", systemSymbol: .docTextMagnifyingglass)
                                Spacer()
                                SystemImage(.chevronForward)
                            }
                        }
                    }
                    Section {
                        ForEach(datasource.suggesstedTokens) { each in
                            HStack(spacing: 2) {
                                Text(each.value.title + " ")
                                +
                                Text(each.key.localized)
                                    .font(.footnote)
                                    .italic()
                                    .foregroundStyle(.secondary)
                                Spacer()
                                SystemImage(.chevronRight)
                                    .foregroundStyle(.quaternary)
                            }
                            .background()
                            .onTapGesture {
                                datasource.setKeyword(each)
                            }
                        }.onDelete { indexSet in
                            indexSet.forEach { i in
                                if let item = datasource.suggesstedTokens[safe: i] {
                                    if let index = SearchStorage.items.firstIndex(of: item.keyValueString) {
                                        SearchStorage.items.remove(at: index)
                                        datasource.suggesstedTokens.remove(at: i)
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Recent Searches")
                    }
                case .emptyResults:
                    ContentUnavailableView.search(text: "\(datasource.searchScope.rawValue): \(datasource.searchText)")
                case .results(let results):
                    Section {
                        ForEach(results) { each in
                            HStack {
                                Text(each)
                            }
                            .overlay {
                                Button {
                                    datasource.onSelectSearchResult(each.string)
                                } label: {
                                    Color.clear
                                }
                            }
                        }
                    }
                case .location(let location):
                    Section {
                        VStack(alignment: .leading) {
                            Text(location.address.text)
                                .fontWeight(.medium)
                            HStack {
                                Text(location.area.title + " Area | ")
                                +
                                Text(location.nearestMRT.mrt.title + " MRT (\(location.nearestMRT.distance)mins) | ")
                                +
                                Text(location.geoInfo.geoHash)
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        }
                    } header: {
                        Text("Address")
                    }
                }
            }
            .animation(.bouncy, value: datasource.result)
        }
    }
}
