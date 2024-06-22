//
//  LookingForFormView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 8/6/23.
//

import SwiftUI
import XUI
import FireAuthManager
struct LookingForFormView: View {

    @StateObject private var model: LookingForFormViewModel
    @Environment(\.dismiss) private var dismiss
    @Injected(\.currentUser) private var currentUser

    init(_ type: Category) {
        _model = .init(wrappedValue: .init(type))
    }
    var body: some View {
        Form {
            Section {
                Picker(selection: $model.looking.category) {
                    ForEach(Category.allCases, id: \.rawValue) {
                        Text($0 == .selling ? "Buying" : $0.title)
                            .tag($0)
                    }
                } label: {
                    Text("")
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear.hidden())

            Section {
                _VFormRow(title: "Title", isEmpty: model.looking.title.isWhitespace) {
                    TextField("Please input the title", text: $model.looking.title, axis: .vertical)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }

                XNavPickerBar("Property Type", PropertyType.allCases, $model.looking.propertyType)

                XNavPickerBar("Room Type", RoomType.allCases, $model.looking.roomType)
                    ._hidable(model.looking.category != .rental_room)

                XNavPickerBar("Occupant", Occupant.allCases, $model.looking._occupant)
                    ._hidable(model.looking.category == .selling)

                MRTListPickerBar(selections: $model.mrts, allowMultiple: true)
                _NumberTextField(value: $model.looking.price_max, title: "Maximum Price", delima: "$")

                DatePicker("Target Date", selection: $model.looking.targetedDate, displayedComponents: .date)
            }

            Section {
                _VFormRow(title: "Detils Descriptions", isEmpty: model.looking.description.isWhitespace) {
                    TextField("Text..", text: $model.looking.description, axis: .vertical)
                        .lineLimit(10...)
                }
            }

            Section {
                HStack {
                    Text("Phone")
                        .foregroundStyle(model.looking.phone.isWhitespace ? .primary : .tertiary)

                    TextField("phone number", text: $model.looking.phone)
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .animation(.interactiveSpring(), value: model.looking.category)
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitle("Looking for")
        .navigationBarItems(leading: leadingItem(), trailing: trailingItem())
        .safeAreaInset(edge: .bottom) {
            LookingForFormSubmitButton()
                .environmentObject(model)
                .padding()
                ._hidable(!model.isValid)
        }
        .embeddedInNavigationView()
    }

    private func leadingItem() -> some View {
        _ConfirmButton("sure to reset") {
            model.mrts.removeAll()
            model.looking = .init(category: model.looking.category)
        } label: {
            Text("Reset")
        }
        .disabled(model.isEmpty)
    }

    private func trailingItem() -> some View {
        _DismissButton(isProtected: !model.isEmpty, title: "Close")
    }
}
