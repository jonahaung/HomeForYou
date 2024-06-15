//
//  PostFilterView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI
import XUI

struct PostsFilterView: View {
    
    @EnvironmentObject private var storage: PostQueryStorage
    @State private var quries: [PostQuery]
    private let onSelectQueries: ([PostQuery]) async -> Void
    @Environment(\.dismiss) private var dismiss
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils
    
    private let allowedQueries = [PostKey.propertyType, .roomType, .furnishing, .baths, .beds, .floorLevel, .tenantType, .leaseTerm, .tenure]
    
    init(_ quries: [PostQuery], onSelectQueries: @MainActor @escaping ([PostQuery]) async -> Void) {
        self.quries = quries
        self.onSelectQueries = onSelectQueries
    }
    
    var body: some View {
        Form {
            Section {
                
            } header: {
                Picker("", selection: $storage.scope) {
                    ForEach(PostExplorer.PostQueryScope.allCases) { each in
                        Text(each.rawValue)
                            .tag(each)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            switch storage.scope {
            case .Accurate:
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
            case .Possibilities:
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
            case .Price:
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
                    _ConfirmButton("Reset all filters") {
                        storage.updateQueries(queries: self.quries)
                    } label: {
                        Text("Reset")
                    }
                    _ConfirmButton("Clear all filters") {
                        storage.configureDatas(rules: self.allowedQueries)
                    } label: {
                        Text("Clear")
                    }
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AsyncButton {
                    let queries = storage.getPostQuries()
                    print(queries)
                    await onSelectQueries(queries)
                } label: {
                    Text("Done")
                } onFinish: {
                    dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .embeddedInNavigationView()
        .task {
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
