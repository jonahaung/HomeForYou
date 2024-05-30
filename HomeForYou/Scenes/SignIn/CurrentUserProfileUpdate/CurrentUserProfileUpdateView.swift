//
//  CurrentUserProfileUpdateView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/5/24.
//

import SwiftUI
import FireAuthManager
import FirebaseAuth
import MediaPicker
import XUI

public struct CurrentUserProfileUpdateView: View {
    
    @Bindable var currentUser: CurrentUser
    @State private var viewModel = CurrentUserProfileUpdateViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.notificationCenter) private var notificationCenter
    
    public var body: some View {
        Form {
            if let user = currentUser.user {
                Section {
                    AlignedStack(.center) {
                        PhotoPickupButton(pickedImage: $viewModel.pickedImage) { state in
                            switch state {
                            case .empty:
                                AsyncImage(url: .init(string: currentUser.photoURL)) { state in
                                    switch state {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .clipShape(Circle())
                                    case .failure(let error):
                                        Image(systemSymbol: .photoCircleFill)
                                            .resizable()
                                            .scaledToFit()
                                            .tint(Color(uiColor: .tertiaryLabel))
                                    @unknown default:
                                        fatalError()
                                    }
                                }
                            case .loading(let progress):
                                ProgressView()
                            case .success(let content):
                                Image(uiImage: content)
                                    .resizable()
                                    .clipShape(Circle())
                            case .failure(let error):
                                SystemImage(.exclamationmarkCircleFill)
                            }
                        }
                        .frame(square: 250)
                    }
                } footer: {
                    HStack {
                        Spacer()
                        if let url = URL(string: currentUser.photoURL) {
                            ShareLink(items: [url], subject: Text(currentUser.displayName), message: Text(currentUser.photoURL)) {
                                SystemImage(.squareAndArrowUp, 33)
                            }
                        }
                    }
                    Text(currentUser.photoURL)
                        .italic()
                        .multilineTextAlignment(.leading)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                Section {
                    _FormCell {
                        TextField("Display Name", text: $currentUser.displayName)
                            .textContentType(.givenName)
                            .textInputAutocapitalization(.words)
                            .submitLabel(.done)
                    } right: {
                        SystemImage(.squareAndPencil)
                            .foregroundStyle(.quinary)
                    }.swipeActions {
                        Button {
                            
                        } label: {
                            Text("Edit")
                        }
                    }
                    Text("Phone")
                        .badge(currentUser.phoneNumber)
                    Text("Email")
                        .badge(currentUser.email)
                }
                Section {
                    Text("Providers")
                        .badge(user.providerData.map{ $0.providerID }.joined(separator: ", "))
                    Text("Last Sign In")
                        .badge(user.metadata.lastSignInDate?.formatted(date: .abbreviated, time: .shortened) ?? "")
                    Text("Created At")
                        .badge(user.metadata.creationDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                    Text("Email Verified")
                        .badge(user.isEmailVerified.description)
                    if !user.isEmailVerified {
                        AsyncButton {
                            try await user.sendEmailVerification()
                            try await currentUser.reload()
                        } label: {
                            Text("Verify Email")
                        } onFinish: {
                            viewModel.showAlert(.init(title: "Sussess", message: "Verification email sent"))
                        } onError: { error in
                            viewModel.showAlert(.init(error: error))
                        }
                    }
                }
                Section {
                    Text("Update Phone Number")
                        ._presentSheet {
                            AuthFlowView(currentUser: currentUser)
                        }
                    AsyncButton {
                        
                    } label: {
                        Text("Update Email Address")
                    }
                    AsyncButton {
                        
                    } label: {
                        Text("Change Password")
                    }
                    AsyncButton {
                        try await Auth.auth().sendPasswordReset(withEmail: currentUser.email)
                    } label: {
                        Text("Request Password Reset Link")
                    } onFinish: {
                        viewModel.showAlert(.init(title: "Password reset email sent"))
                    }
                }
                Section {
                    Text("Delete User Account")
                        ._comfirmationDialouge {
                            AsyncButton {
                                try await viewModel.profileUpder.update(.deleteAccount, user: user)
                            } label: {
                                Text("Confirm Delete")
                            } onFinish: {
                                viewModel.showAlert(
                                    .init(title: "Success", message: "User deleted") {
                                        dismiss()
                                    }
                                )
                            }
                        }
                        .tint(.red)
                }
                Section {
                    Text("Sign Out")
                        ._borderedProminentButtonStyle()
                        ._comfirmationDialouge {
                            AsyncButton {
                                try await currentUser.signOut()
                            } label: {
                                Text("Continue Log Out")
                            } onFinish: {
                                dismiss()
                            }
                        }
                }
                .listRowBackground(EmptyView())
            }
        }
        .onSubmit {
            if viewModel.hasUpdates(currentUser) {
                Task {
                    await viewModel.updateProfile(to: currentUser)
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .showLoading(viewModel.loading)
        .alertPresenter($viewModel.alert)
        .navigationTitle("@account")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                AsyncButton {
                    viewModel.pickedImage = nil
                    try await currentUser.reload()
                } label: {
                    Text("Reset")
                }
                .disabled(!viewModel.hasUpdates(currentUser))
            }
            ToolbarItem(placement: .confirmationAction) {
                AsyncButton {
                    await viewModel.updateProfile(to: currentUser)
                    try await currentUser.reload()
                    notificationCenter.post(title: "Success", subtitle: "Profile Update", body: "Your profile has updated successfully")
                } label: {
                    Text("Apply Update")
                }
                .disabled(!viewModel.hasUpdates(currentUser))
            }
        }
    }
}
