//
//  SignInView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import SwiftUI
import XUI
import FireAuthManager

public struct SignInView: View {
    
    @Injected(\.currentUser) private var currentUser
    @Environment(\.dismiss) private var dismiss
    
    public init(){}
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(square: 250)
                .clipShape(Circle())
                .padding()
            Text("Sign In")
                ._borderedProminentButtonStyle()
                ._tapToPush {
                    AuthFlowView(currentUser: currentUser)
                }
            Spacer()
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                _DismissButton(isProtected: true, title: "Cancel")
            }
        }
        .embeddedInNavigationView()
        .interactiveDismissDisabled()
        .onChange(of: currentUser.isLoggedIn) { oldValue, newValue in
            if !oldValue && newValue {
                dismiss()
            }
        }
    }
}
