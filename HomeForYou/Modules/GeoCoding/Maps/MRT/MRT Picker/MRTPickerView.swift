//
//  MRTListPicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 15/6/23.
//

import SwiftUI
import XUI

struct MRTPickerView: View {
    
    @Binding var selections: [MRT]
    let allowMultiple: Bool
    @State private var selected: MRT?
    
    @State private var multiSelection = Set<Int>()
    @AppStorage("MRT Line Type") private var lineType: MRTLine = .DT
    @State private var allItems = [MRT]()
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    private var currentItems: [MRT] {
        return searchText.isWhitespace ? (currentMode == .Selections ? selectedItems() : allItems) : MRT.allValues.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    enum Mode: String, CaseIterable {
        case MRTs, Selections
    }
    @State private var currentMode = Mode.MRTs
    
    var body: some View {
        List {
            Section {
                ForEach(currentItems) { mrt in
                    MRTListCell(mrt: mrt, isSelected: .init(get: {
                        if allowMultiple {
                            multiSelection.contains(mrt.id)
                        } else {
                            mrt == selected
                        }
                    }, set: { _ in
                        toggleSelect(mrt)
                    }))
                }
            } header: {
                HStack {
                    Picker.init("Display Mode", selection: $currentMode) {
                        ForEach(Mode.allCases, id: \.rawValue) { each in
                            Text(each.rawValue)
                                .tag(each)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    
                    Button {
                        currentMode = (currentMode == .Selections || multiSelection.isEmpty) ? .MRTs : .Selections
                    } label: {
                        Image(systemName: "\(multiSelection.count)")
                            .symbolVariant(currentMode == .Selections ? .circle.fill : .circle)
                            .font(.title2)
                    }
                    .buttonStyle(.borderless)
                }
                .textCase(nil)
                .disabled(multiSelection.isEmpty)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(currentMode == .Selections ? "Selected Items" : lineType.name, displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .bottom, spacing: 0) {
                Spacer()
                ForEach(MRTLine.allCases) { item in
                    Button {
                        self.lineType = item
                    } label: {
                        SystemImage(.circleFill, item == self.lineType ? 60 : 30)
                            .foregroundColor(item.color)
                    }
                }
                Spacer()
            }
            ._hidable(!searchText.isWhitespace || currentMode == .Selections)
            .animation(.interactiveSpring, value: lineType)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                leadingItem()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                trailingItem()
            }
        }
        .onChange(of: lineType) { oldValue, newValue in
            allItems = newValue.mrts
            currentMode = .MRTs
        }
        .onChange(of: multiSelection) { _, newValue in
            if newValue.isEmpty {
                currentMode = .MRTs
            }
        }
        .task {
            multiSelection = Set(selections.map { $0.id })
            allItems = lineType.mrts
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func leadingItem() -> some View {
        HStack {
            SystemImage(.mappinAndEllipse)
                ._presentFullScreen {
                    MRTMapView(selection: selected, selectedService: .init(lineType)) { mrt in
                        toggleSelect(mrt)
                    }
                }
            _ConfirmButton("Clear All") {
                multiSelection.removeAll()
            } label: {
                Text("Clear")
            }
        }
    }
    
    private func trailingItem() -> some View {
        AsyncButton {
            self.selections = selectedItems()
            try await Task.sleep(for: .seconds(0.3))
            dismiss()
        } label: {
            Text("Done")
        }
        .disabled(allowMultiple ? selections.isEmpty : selected == nil)
    }
    
    private func selectedItems() -> [MRT] {
        if allowMultiple {
            var items = [MRT]()
            multiSelection.forEach { each in
                if let mrt = MRT.allValues.first(where: { item in
                    item.id == each
                }) {
                    items.append(mrt)
                }
            }
            return items
        } else {
            if let selected {
                return [selected]
            }
            return []
        }
    }
    
    private func toggleSelect(_ newValue: MRT) {
        if allowMultiple {
            if multiSelection.contains(newValue.id) {
                multiSelection.remove(newValue.id)
            } else {
                multiSelection.insert(newValue.id)
            }
        } else {
            selected = selected == newValue ? nil : newValue
            
        }
    }
}
