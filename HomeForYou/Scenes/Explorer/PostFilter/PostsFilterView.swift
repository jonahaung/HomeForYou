//
//  PostFilterView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI
import XUI

struct PostsFilterView: View {
    
    @StateObject private var model = PostsFilterViewModel()
    @Environment(\.dismiss) private var dismiss
    @Injected(\.ui) private var ui
    @Injected(\.utils) private var utils
    
    @Binding private var quries: [PostQuery]
    
    init(_ filters: Binding<[PostQuery]>) {
        self._quries = filters
    }
    
    var body: some View {
        Form {
            
            Section {
                
                Toggle(isOn: $model.isPriceSearch) {
                    Text("Filter by price range")
                }
                
                if model.isPriceSearch {
                    RangedSliderView(value: $model.priceRange, bounds: 0...1000, step: 100)
                        .padding(.horizontal)
                        .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .padding(.vertical)
                        .listRowBackground(EmptyView())
                }
                
            }
            .animation(.interactiveSpring(), value: model.isPriceSearch)
            
            if !model.isPriceSearch {
                Section {
                    XNavPickerBar("Area", model.allCasesSting(for: .area), model.bindableValue(for: .area))
                    MRTPickerBar(mrt: model.bindableValue(for: .mrt))
                }
                Section {
                    Group {
                        XNavPickerBar(
                            "Property Type",
                            model.allCasesSting(
                                for: .propertyType
                            ),
                            model.bindableValue(
                                for: .propertyType
                            )
                        )
                        XNavPickerBar(
                            "Room Type",
                            model.allCasesSting(
                                for: .roomType
                            ),
                            model.bindableValue(
                                for: .roomType
                            )
                        )
                        ._hidable(model.category != .rental_room)
                        XNavPickerBar(
                            "Furnishing",
                            model.allCasesSting(
                                for: .furnishing
                            ),
                            model.bindableValue(
                                for: .furnishing
                            )
                        )
                        ._hidable(model.category == .selling)
                    }
                    Group {
                        XNavPickerBar(
                            "Bedrooms",
                            model.allCasesSting(
                                for: .beds
                            ),
                            model.bindableValue(
                                for: .beds
                            )
                        )
                        XNavPickerBar(
                            "Bathrooms",
                            model.allCasesSting(
                                for: .baths
                            ),
                            model.bindableValue(
                                for: .baths
                            )
                        )
                    }
                    ._hidable(model.category == .rental_room)
                    
                    Group {
                        XNavPickerBar(
                            "FloorLevel",
                            model.allCasesSting(
                                for: .floorLevel
                            ),
                            model.bindableValue(
                                for: .floorLevel
                            )
                        )
                        XNavPickerBar(
                            "TenantType",
                            model.allCasesSting(
                                for: .tenantType
                            ),
                            model.bindableValue(
                                for: .tenantType
                            )
                        )
                        ._hidable(model.category == .selling)
                        XNavPickerBar(
                            "LeaseTerm",
                            model.allCasesSting(
                                for: .leaseTerm
                            ),
                            model.bindableValue(
                                for: .leaseTerm
                            )
                        )
                        ._hidable(model.category == .selling)
                        XNavPickerBar(
                            "Tenure",
                            model.allCasesSting(
                                for: .tenure
                            ),
                            model.bindableValue(
                                for: .tenure
                            )
                        )
                        ._hidable(model.category != .selling)
                    }
                }
                .font(ui.fonts.callOut)
                Section("Features") {
                    GridMultiPicker(source: Feature.allCases, selection: model.getBindableModels(for: .features))
                }
                Section("Restrictions") {
                    GridMultiPicker(source: Restriction.allCases, selection: model.getBindableModels(for: .restrictions))
                }
                Section("Status") {
                    Picker("", selection: model.bindableValue(for: .status)) {
                        ForEach(PostStatus.allCasesExpectEmpty) {
                            Text($0.title)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
                .listRowBackground(Color.clear)
            }
        }
        .animation(.interactiveSpring(), value: model.quries)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                HStack {
                    _ConfirmButton("Reset all filters") {
                        model.quries.removeAll()
                    } label: {
                        Text("Reset")
                    }
                    .disabled(quries == model.quries)
                    
                    _ConfirmButton("Clear all filters") {
                        model.quries.removeAll()
                    } label: {
                        Text("Clear")
                    }
                    .disabled(model.quries.isEmpty)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                _DismissButton(title: "Done")
            }
        }
        .navigationBarTitle("Filter Posts", displayMode: .inline)
        .embeddedInNavigationView()
        .debounceSync($quries, $model.quries, 1)
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled(true)
    }
}
