//
//  SettingsView.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI
import XUI

struct SettingsView: View {
    
    @Injected(\.ui) private var ui
    
    var body: some View {
        Form {
            SettingsCurrentUserSection()
            Section {
                LanguagePickerView()
            } header: {
                Text("Change Language")
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            Section {
                ListRowLabel(alignment: .leading, .paintbrushFill, L10n_.Screen.Settings.Form.appearance_settings)
                    .routableNav(to: SceneItem(.appThemeSettings))
                LinkButton(.appSettings) {
                    ListRowLabel(alignment: .leading, .appleLogo, L10n_.Screen.Settings.Form.open_device_settings)
                }
                ListRowLabel(alignment: .leading, .computermouseFill, L10n_.Screen.Settings.Form.developer_controls)
                    .routableNav(to: SceneItem(.developerControl))
            }
            
            Section {
                Text(L10n_.Screen.Settings.Form.onboarding_tutorials)
                    .presentable(SceneItem(.onboarding), .fullScreenCover)
                Text(L10n_.Screen.Settings.Form.terms_and_conditions)
                    .presentable(SceneItem(.eula), .sheet)
                Text(L10n_.Screen.Settings.Form.contact_us)
                    .presentable(SceneItem(.developerControl), .sheet)
            }
        }
        .font(L10n_.isMyanmar ? ui.fonts.callOut : nil)
    }
}
