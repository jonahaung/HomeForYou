//
//  PostFilterView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI
import XUI
import SwiftyTheme

struct PostFilterOptionView: View {
    
    
    @Binding var query: CompoundQuery
    @Binding var showView: Bool
    @EnvironmentObject private var storage: FirebasePostQueryStorage
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("", selection: $storage.query.queryType) {
                        ForEach(CompoundQuery.QueryType.allCases) { each in
                            Text(each.title)
                                .tag(each)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .listRowInsets(.init())
                .listRowBackground(Color.clear.hidden())
                .onChange(of: storage.query.queryType) { oldValue, newValue in
                    storage.query.values.removeAll()
                }
                
                switch storage.query.queryType {
                case .accurate:
                    Section {
                        listCell(for: .area)
                        listCell(for: .mrt)
                    }
                    Section {
                        ForEach(storage.allowedQueries) { each in
                            listCell(for: each)
                        }
                    }
                    Section("Status") {
                        Picker("", selection: storage.bindableValue(for: .status)) {
                            ForEach(PostStatus.allCasesExpectEmpty) {
                                Text($0.title)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                    .listRowBackground(Color.clear.hidden())
                case .keywords:
                    Section("Features") {
                        GridMultiPicker(source: Feature.allCases.filter{ $0 != .Any }, selection: storage.features)
                    }
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear.hidden())
                    Section("Restrictions") {
                        GridMultiPicker(source: Restriction.allCases.filter{ $0 != .Any }, selection: storage.restictions)
                    }
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear.hidden())
                    Section {
                        listCell(for: .area)
                        listCell(for: .mrt)
                    }
                    Section {
                        ForEach(storage.allowedQueries) { each in
                            listCell(for: each)
                        }
                    }
                    Section("Status") {
                        Picker("", selection: storage.bindableValue(for: .status)) {
                            ForEach(PostStatus.allCasesExpectEmpty) {
                                Text($0.title)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                    .listRowBackground(Color.clear.hidden())
                case .priceRange:
                    RangedSliderView(value: storage.priceRange, bounds: PriceRange.defaultRange(for: .current), step: PriceRange.defaultSteps(for: .current))
                        .listRowInsets(.init())
                        .padding(.vertical)
                        .listRowBackground(EmptyView())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .animation(.interactiveSpring, value: storage.query)
            .safeAreaInset(edge: .bottom) {
                AsyncButton {
                    self.query = storage.createQuery()
                } label: {
                    Text("Comfirm Selection")
                } onFinish: {
                    showView = false
                }
                ._borderedProminentButtonStyle()
                .disabled(hasNoChanges)
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    HStack {
                        _ConfirmButton("Clear all filters") {
                            storage.clearQueries()
                        } label: {
                            Text("Clear")
                        }
                        .disabled(!hasSelectedItems)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    AsyncButton {
                        if hasNoChanges {
                            showView = false
                        } else {
                            storage.query = query
                        }
                    } label: {
                        Text(hasNoChanges ? "Close" : "Reset")
                    }
                }
            }
            .taskOnce(id: query, { newValue in
                await MainActor.run {
                    self.storage.query = query
                }
            })
            .navigationBarTitleDisplayMode(.inline)
        }
        .swiftyThemeStyle()
        .ignoresSafeArea(.keyboard)
        .presentationDetents([.fraction(0.75), .large])
        .presentationBackground(Color.systemGroupedBackground)
        .interactiveDismissDisabled(true)
    }
    private var hasNoChanges: Bool {
        query == storage.query
    }
    private var hasSelectedItems: Bool {
        !storage.query.values.isEmpty
    }
    private func listCell(for key: PostKey) -> some View {
        HStack {
            CircleSystemImage(key.symbol, Color.secondary)
                .padding(.trailing, 8)
            XNavPickerBar(key.typeName, storage.allCases(for: key), storage.bindableValue(for: key))
        }
    }
}
