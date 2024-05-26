//
//  LanguagePickerView.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 20/1/23.
//

import SwiftUI
import L10n_swift

struct LanguagePickerView: View {

    var body: some View {
        Picker("Change Language", selection: .init(get: {
            L10n.shared.language
        }, set: { newValue in
            L10n.shared.language = newValue
        })) {
            ForEach(L10n.shared.supportedLanguages, id: \.self) {
                Text(.init($0))
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }
}
