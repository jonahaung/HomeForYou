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
    @Binding var quries: [PostQuery]
    @Environment(\.dismiss) private var dismiss
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils
    
    private let allowedQueries = [PostKey.propertyType, .roomType, .furnishing, .baths, .beds, .floorLevel, .tenantType, .leaseTerm, .tenure]
    
    var body: some View {
        Form {
            Section {
                
            } header: {
                Picker("", selection: $storage.scope) {
                    ForEach(PostExplorer.FilterType.allCases) { each in
                        Text(each.title)
                            .tag(each)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            switch storage.scope {
            case .exactMatch:
                Section {
                    listCell(for: .area)
                    listCell(for: .mrt)
                }
                Section {
                    ForEach(allowedQueries) { each in
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
                    GridMultiPicker(source: Feature.allCases, selection: $storage.features)
                }
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
                Section("Restrictions") {
                    GridMultiPicker(source: Restriction.allCases, selection: $storage.restictions)
                }
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
                Section {
                    listCell(for: .area)
                    listCell(for: .mrt)
                }
                Section {
                    ForEach(allowedQueries) { each in
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
        .animation(.interactiveSpring(), value: storage.scope)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                HStack {
                    _ConfirmButton("Clear all filters") {
                        storage.clearQueries()
                    } label: {
                        Text("Clear")
                    }
                    .disabled(quries == storage.quries)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AsyncButton {
                    let queries = storage.quries
                    storage.clearQueries()
                    self.quries = queries
                } label: {
                    Text("Done")
                } onFinish: {
                    dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .embeddedInNavigationView()
        .onAppear {
            storage.updateQueries(queries: self.quries)
        }
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled(true)
    }
    
    private func listCell(for key: PostKey) -> some View {
        HStack {
            SystemImage(key.symbol, 22)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary.gradient)
                .padding(.trailing, 8)
                .imageScale(.large)
                .foregroundStyle(.secondary)
            XNavPickerBar(key.typeName, storage.allCases(for: key), storage.bindableValue(for: key))
        }
    }
}
