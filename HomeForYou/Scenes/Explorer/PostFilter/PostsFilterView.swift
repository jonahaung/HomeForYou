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
    
    private var filters: Binding<[PostFilter]>
    
    init(_ filters: Binding<[PostFilter]>) {
        self.filters = filters
    }
    
    var body: some View {
        Form {
            
            Section {
                
                Toggle(isOn: $model.filters.isPriceRange) {
                    Text("Filter by price range")
                }
                
                if model.filters.isPriceRange {
                    RangedSliderView(value: $model.filters.priceRange, bounds: 0...1000, step: 100)
                        .padding(.horizontal)
                        .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .padding(.vertical)
                        .listRowBackground(EmptyView())
                }
                
            }
            .animation(.interactiveSpring(), value: model.filters.isPriceRange)
            
            if !model.filters.isPriceRange {
                Section {
                    XNavPickerBar("Area", Area.allCases, $model.filters.area)
                    MRTPickerBar(mrt: $model.filters.mrt)
                }
                
                Section {
                    Group {
                        XNavPickerBar("Property Type", PropertyType.allCases, $model.filters.propertyType)
                        XNavPickerBar("Room Type", RoomType.allCases, $model.filters.roomType)
                            ._hidable(model.filters.category != .rental_room)
                        XNavPickerBar("Furnishing", Furnishing.allCases, $model.filters.furnishing)
                            ._hidable(model.filters.category == .selling)
                    }
                    
                    Group {
                        XNavPickerBar("Bedrooms", Bedroom.allCases, $model.filters.bedroom)
                        XNavPickerBar("Bathrooms", Bathroom.allCases, $model.filters.bathroom)
                    }
                    ._hidable(model.filters.category == .rental_room)
                    
                    Group {
                        XNavPickerBar("FloorLevel", FloorLevel.allCases, $model.filters.floorLevel)
                        XNavPickerBar("TenantType", TenantType.allCases, $model.filters.tenantType)
                            ._hidable(model.filters.category == .selling)
                        XNavPickerBar("LeaseTerm", LeaseTerm.allCases, $model.filters.leaseTerm)
                            ._hidable(model.filters.category == .selling)
                        XNavPickerBar("Tenure", Tenure.allCases, $model.filters.tenure)
                            ._hidable(model.filters.category != .selling)
                    }
                }
                .font(ui.fonts.callOut)
                Section("Features") {
                    GridMultiPicker(source: Feature.allCases, selection: $model.filters.features)
                }
                
                Section("Restrictions") {
                    GridMultiPicker(source: Restriction.allCases, selection: $model.filters.restrictions)
                }
                
                Section("Status") {
                    Picker("", selection: $model.filters.status) {
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
        .animation(.interactiveSpring(), value: model.filters)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                HStack {
                    _ConfirmButton("Reset all filters") {
                        model.filters = .init(self.filters.wrappedValue, category: .current)
                    } label: {
                        Text("Reset")
                    }
                    .disabled(filters.wrappedValue == model.filters.getFilters())
                    
                    _ConfirmButton("Clear all filters") {
                        model.filters.clear()
                    } label: {
                        Text("Clear")
                    }
                    .disabled(model.filters.isEmpty)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                _DismissButton(title: "Done")
            }
        }
        .navigationBarTitle("Filter Posts", displayMode: .inline)
        .embeddedInNavigationView()
        .lazySync(filters, .init(get: {
            model.filters.getFilters()
        }, set: { new in
            model.filters = .init(new, category: model.filters.category)
        }))
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled(true)
    }
}
