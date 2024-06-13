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
    
    @Environment(\.makeRequestPostUpdate) private var onTakePostingAction
    @Binding private var editablePost: T
    
    init(_ editablePost: Binding<T>) {
        self._editablePost = editablePost
    }
    
    var body: some View {
        List {
            Section {
                _VFormRow(title: "Title", isEmpty: editablePost.title.isEmpty) {
                    TextField("Please input the title", text: $editablePost.title, axis: .vertical)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }

                _NumberTextField(value: $editablePost.price, title: "Price", delima: "$")
            } header: {
                Text(editablePost.getPostCaption())
                    .textCase(nil)
            }

            Section("Description") {
                TextField("Add a short description..", text: $editablePost.description, axis: .vertical)
                    .lineLimit(5...)
            }

            Section {
                _VFormRow(title: "Phone", isEmpty: editablePost.phoneNumber.isWhitespace) {
                    TextField("Please input your phone number", text: $editablePost.phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .safeAreaInset(edge: .bottom) {
            AsyncButton(actionOptions: [.showProgressView]) {
                await onTakePostingAction?(editablePost.views.count > 0 ? .update(editablePost) : .upload(editablePost))
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
                    editablePost.title = Lorem.shortTweet
                    editablePost.description = Lorem.paragraphs(3)
                    editablePost.propertyType = PropertyType.allCases.random()!
                }
            }
        }
    }
    private func isValid() -> Bool {
        !editablePost.title.isWhitespace &&
        !editablePost.description.isWhitespace &&
        !editablePost.phoneNumber.isWhitespace &&
        editablePost.price > 0
    }
}
