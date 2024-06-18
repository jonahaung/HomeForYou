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
    @Environment(\.onSearchAction) private var onSearchAction
    @StateObject private var locationReceiver = CurrentLocationReceiver()
    
    var body: some View {
        if datasource.isPresented {
            List {
                switch datasource.result {
                case .suggestions:
                    Section {
                        _Label {
                            SystemImage(.locationFill)
                                .foregroundStyle(.secondary)
                        } right: {
                            AsyncButton {
                                locationReceiver.start()
                            } label: {
                                Text("Use my current location")
                            }
                        }
                        
                        _Label {
                            SystemImage(.mapCircle)
                                .foregroundStyle(.secondary)
                        } right: {
                            AsyncButton {
                                datasource.canPresentOnAppear = true
                                await onSearchAction?(.locationPickerMap)
                            } label: {
                                Text("Select location on map")
                            }
                        }
                        _Label {
                            SystemImage(.mappinAndEllipse)
                                .foregroundStyle(.secondary)
                        } right: {
                            AsyncButton {
                                datasource.canPresentOnAppear = true
                                await onSearchAction?(.areaMap)
                            } label: {
                                Text("Set area on map")
                            }
                        }
                        _Label {
                            SystemImage(.mappinSquare)
                                .foregroundStyle(.secondary)
                        } right: {
                            AsyncButton {
                                datasource.canPresentOnAppear = true
                                await onSearchAction?(.mrtMap)
                            } label: {
                                Text("Select from MRT map")
                            }
                        }
                    } header: {
                        Text("Advanced searches")
                    }
                    
                    Section {
                        _Label {
                            SystemImage(.docTextMagnifyingglass)
                                .foregroundStyle(.secondary)
                        } right: {
                            AsyncButton {
                                datasource.canPresentOnAppear = true
                                await onSearchAction?(.exploreAllPost)
                            } label: {
                                Text("Explore all posts")
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
            .imageScale(.large)
            .animation(.bouncy, value: datasource.result)
            .onChange(of: locationReceiver.coordinate, {
                if let newValue = locationReceiver.coordinate {
                    datasource.canPresentOnAppear = true
                    locationReceiver.reset()
                    Task {
                        await onSearchAction?(.filter([.init(.area, newValue.geohash(length: 6))]))
                    }
                }
            })
        }
    }
}
