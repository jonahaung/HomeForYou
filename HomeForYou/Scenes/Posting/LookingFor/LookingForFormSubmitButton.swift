//
//  LookingForFormSubmitButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 23/6/23.
//

import SwiftUI
import XUI
import FireAuthManager
struct LookingForFormSubmitButton: View {

    @EnvironmentObject private var model: LookingForFormViewModel
    var onFinish: (@Sendable @MainActor (() -> Void) -> Void)?

    @Injected(\.currentUser) private var currentUser
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        AsyncButton {
            model.looking.authorID = currentUser.uid
            model.looking.mrts = model.mrts.map { $0.name }.sorted()
            try await Repo.shared.async_add(model.looking)
        } label: {
            Text("Submit")
                ._borderedProminentButtonStyle()
        } onFinish: {
            finish()
        } onError: {
            print($0.localizedDescription)
        }
    }

    @MainActor
    private func finish() {
        if let onFinish {
            onFinish {
                dismiss()
            }
        } else {
            dismiss()
        }
    }
}
