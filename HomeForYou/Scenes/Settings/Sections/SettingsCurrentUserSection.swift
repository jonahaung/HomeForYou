//
//  HomeCurrentUserSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/5/24.
//

import SwiftUI
import XUI
import FireAuthManager
import URLImage

struct SettingsCurrentUserSection: View {
    
    @Environment(CurrentUser.self) private var currentUser
    @Environment(AppReloader.self) private var appReloader
    var body: some View {
        Group {
            if currentUser.isLoggedIn {
                Section {
                    AlignedStack(.center) {
                        URLImage(url: .init(string: currentUser.photoURL), imageSize: .medium)
                            .frame(square: 220)
                            .clipShape(Circle())
                            ._presentSheet {
                                PhotoGalleryView(attachments: [.init(url: currentUser.photoURL, type: .photo)], title: currentUser.displayName, selection: .constant(0))
                            }
                    }
                    .padding()
                }
                .listRowBackground(EmptyView())
            }
            Section {
                if currentUser.isLoggedIn {
                    Text(L10n_.Screen.Settings.Form.name)
                        .badge(currentUser.displayName)
                    Text(L10n_.Screen.Settings.Form.phone)
                        .badge(currentUser.phoneNumber)
                    ListRowLabel(alignment: .leading, .personBadgeKeyFill, L10n_.Screen.Settings.Form.profile_settings)
                        ._tapToPush { CurrentUserProfileUpdateView(currentUser: currentUser) }
                }
            } footer: {
                if !currentUser.isLoggedIn {
                    Text("Sign In")
                        ._borderedProminentButtonStyle()
                        ._presentSheet {
                            AuthFlowView(currentUser: currentUser)
                        }
                }
            }
        }
    }
}
