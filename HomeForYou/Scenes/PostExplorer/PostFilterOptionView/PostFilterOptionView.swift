//
//  PostFilterView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI
import XUI

struct PostFilterOptionView: View {
    
    @EnvironmentObject private var storage: PostQueryStorage
    @Binding var query: CompoundQuery
    @Environment(\.dismiss) private var dismiss
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils
    
    var body: some View {
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
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
            
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
                .listRowBackground(Color.clear)
            case .keywords:
                Section("Features") {
                    GridMultiPicker(source: Feature.allCases.filter{ $0 != .Any }, selection: storage.features)
                }
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
                Section("Restrictions") {
                    GridMultiPicker(source: Restriction.allCases.filter{ $0 != .Any }, selection: storage.restictions)
                }
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
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
                .listRowBackground(Color.clear)
            case .priceRange:
                RangedSliderView(value: $storage.priceRange, bounds: 0...1000, step: 100)
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    .padding(.vertical)
                    .listRowBackground(EmptyView())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.interactiveSpring, value: storage.query)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                HStack {
                    _ConfirmButton("Clear all filters") {
                        storage.clearQueries()
                    } label: {
                        Text("Clear")
                    }
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AsyncButton {
                    self.query = storage.query
                } label: {
                    Text("Done")
                } onFinish: {
                    dismiss()
                }
            }
        }
        .taskOnce(id: query, { newValue in
            await MainActor.run {
                self.storage.query = query
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .embeddedInNavigationView()
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled(true)
    }
    
    private func listCell(for key: PostKey) -> some View {
        HStack {
            CircleSystemImage(key.symbol, Color.secondary)
                .padding(.trailing, 8)
            XNavPickerBar(key.typeName, storage.allCases(for: key), storage.bindableValue(for: key))
        }
    }
}
