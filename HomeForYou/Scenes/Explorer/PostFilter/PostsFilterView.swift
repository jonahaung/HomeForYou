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

            if !model.filters.isEmpty {
                Section {
                    FilterTagsView(filters: .init(get: {
                        model.filters.getFilters()
                    }, set: { new in
                        model.filters = .init(new, category: .current)
                    }))
                }
                .listRowBackground(EmptyView())
            }

            Section {

                Toggle(isOn: $model.filters.isPriceRange) {
                    Text("Filter by price range")
                }

                if model.filters.isPriceRange {
                    RangedSliderView(value: $model.filters.priceRange, bounds: 0...1000, step: 100)
                        .padding(.horizontal)
//                    RangeSlider(interval: $model.filters.priceRange, in: PriceRange.defaultRange(for: .current), step: PriceRange.defaultSteps(for: .current)) {
//                        let priceRange = PriceRange.integerRange(for: model.filters.priceRange)
//                        if let lowerText = utils.kmbFormatter.string(for: priceRange.lowerBound),
//                           let upperText = utils.kmbFormatter.string(for: priceRange.upperBound) {
//                            Text("\(lowerText) - \(upperText)")
//                        }
//                    } minimumValueLabel: {
//                        Text("\(Int(model.filters.priceRange.lowerBound))")
//                            .font(.caption)
//                    } maximumValueLabel: {
//                        Text("\(KMBFormatter().string(fromNumber: Int(model.filters.priceRange.upperBound)))")
//                            .font(.caption)
//                    } onEditingChanged: { _ in
//                        print("done")
//                    }
                    .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    .padding(.vertical)
                    .listRowBackground(EmptyView())
                }

            } header: {
                Text("Filter by price range")
            }
            .animation(.interactiveSpring(), value: model.filters.isPriceRange)

            Section {
                Picker(selection: $model.filters.category) {
                    ForEach(Category.allCases, id: \.hashValue) {
                        Text($0.title)
                            .tag($0)
                    }
                } label: {
                    Text("Post Type")
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }.listRowBackground(Color.clear)

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
        .synchronizeLazily(filters, .init(get: {
            model.filters.getFilters()
        }, set: { new in
            model.filters = .init(new, category: model.filters.category)
        }))
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled(true)
    }
}
