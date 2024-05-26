//
//  SettingsView++.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/7/23.
//

import SwiftUI
import XUI
import FireAuthManager

extension SettingsView {
    
    struct CurrentUserInfSection: View {
        
        @Environment(CurrentUser.self) private var currentUser
        
        @ViewBuilder var body: some View {
            Section {
                AlignedStack(.center) {
                    AsyncImage(url: .init(string: currentUser.photoURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(square: 220)
                            .clipShape(Circle())
                            .phaseAnimation([.scale(0.8), .rotate(-10), .rotate(10)])
                            ._presentSheet {
                                PhotoGalleryView(attachments: [.init(url: currentUser.photoURL, type: .photo)], title: currentUser.displayName, selection: .constant(0))
                            }
                    } placeholder: {
                        ZStack {
                            ProgressView()
                        }
                        .frame(square: 220)
                    }
                }
                .padding()
            }
            .listRowBackground(EmptyView())
            
            Section {
                if currentUser.isLoggedIn {
                    Text(L10n_.Screen.Settings.Form.name)
                        .badge(currentUser.displayName)
                    Text(L10n_.Screen.Settings.Form.phone)
                        .badge(currentUser.phoneNumber)
                    ListRowLabel(alignment: .leading, .personBadgeKeyFill, L10n_.Screen.Settings.Form.profile_settings)
                        ._tapToPush { CurrentUserProfileUpdateView(currentUser: currentUser) }
                } else {
                    ListRowLabel(alignment: .leading, .keyFill, "Sign In")
                        ._presentSheet {
                            AuthFlowView(currentUser: currentUser)
                        }
                }
            }
        }
    }
}
