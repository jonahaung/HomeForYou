//
//  PostForm+Description.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/7/23.
//

import SwiftUI
import XUI
import FireAuthManager

struct PostForm_Description<T: Postable>: View {
    
    @Binding var postingData: T
    @Environment(\.onTakePostingAction) private var onTakePostingAction

    var body: some View {
        List {
            Section {
                _VFormRow(title: "Title", isEmpty: postingData.title.isEmpty) {
                    TextField("Please input the title", text: $postingData.title, axis: .vertical)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }

                _NumberTextField(value: $postingData.price, title: "Price", delima: "$")
            } header: {
                Text(postingData.getPostCaption())
                    .textCase(nil)
            }

            Section("Description") {
                TextField("Add a short description..", text: $postingData.description, axis: .vertical)
                    .lineLimit(5...)
            }

            Section {
                _VFormRow(title: "Phone", isEmpty: postingData.phoneNumber.isWhitespace) {
                    TextField("Please input your phone number", text: $postingData.phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .safeAreaInset(edge: .bottom) {
            AsyncButton(actionOptions: [.showProgressView]) {
                await onTakePostingAction?(postingData.views.count > 0 ? .update(postingData) : .upload(postingData))
            } label: {
                Text("Submit")
                    ._borderedProminentButtonStyle()
            }
            .padding()
            ._hidable(isValid() == false)
        }
        .navigationTitle("@description")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                _ConfirmButton("close the current form") {
                    await onTakePostingAction?(.cancel)
                } label: {
                    Text("Close")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Auto Fill") {
                    postingData.title = Lorem.shortTweet
                    postingData.description = Lorem.paragraphs(3)
                    postingData.propertyType = PropertyType.allCases.random()!
                }
            }
        }
    }
    private func isValid() -> Bool {
        !postingData.title.isWhitespace &&
        !postingData.description.isWhitespace &&
        !postingData.phoneNumber.isWhitespace &&
        postingData.price > 0
    }
}
