//
//  PostForm+Description.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/7/23.
//

import SwiftUI
import XUI
import FireAuthManager

struct PostForm_Description: View {
    
    var dismiss: DismissAction
    @Binding var postingData: MutablePost
    @Injected(\.currentUser) private var currentUser
    @Environment(PostingFlowRouter.self) private var router
    
    @MainActor
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
                guard let user = currentUser.model else { return }
                try await PostUploader.post(&postingData, author: user.personInfo)
            } label: {
                Text("Submit")
                    ._borderedProminentButtonStyle()
            } onFinish: {
                finish()
            }
            .padding()
            ._hidable(isValid() == false)
        }
        .navigationTitle("@description")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                _ConfirmButton("close the current form") {
                    dismiss()
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

    @MainActor
    private func finish() {
        dismiss()
    }

    private func isValid() -> Bool {
        !postingData.title.isWhitespace &&
        !postingData.description.isWhitespace &&
        !postingData.phoneNumber.isWhitespace &&
        postingData.price > 0
    }
}
