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
    @EnvironmentObject private var post: Post
    @Injected(\.currentUser) private var currentUser
    @Environment(PostingFlowRouter.self) private var router
    
    @MainActor
    var body: some View {
        List {
            Section {
                _VFormRow(title: "Title", isEmpty: post.title.isEmpty) {
                    TextField("Please input the title", text: $post.title, axis: .vertical)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }

                _NumberTextField(value: $post.price, title: "Price", delima: "$")
            } header: {
                Text(post.getPostCaption())
                    .textCase(nil)
            }

            Section("Description") {
                TextField("Add a short description..", text: $post.description, axis: .vertical)
                    .lineLimit(5...)
            }

            Section {
                _VFormRow(title: "Phone", isEmpty: post.phoneNumber.isWhitespace) {
                    TextField("Please input your phone number", text: $post.phoneNumber)
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
                try await PostUploader.post(post, author: user.personInfo)
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
                    post.title = Lorem.shortTweet
                    post.description = Lorem.paragraphs(3)
                    post.propertyType = PropertyType.allCases.random()!
                }
            }
        }
    }

    @MainActor
    private func finish() {
        dismiss()
    }

    private func isValid() -> Bool {
        !post.title.isWhitespace &&
        !post.description.isWhitespace &&
        !post.phoneNumber.isWhitespace &&
        post.price > 0
    }
}
