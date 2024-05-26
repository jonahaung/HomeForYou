//
//  L10n.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import Foundation
import L10n_swift

internal enum L10n_ {
    internal static var isMyanmar: Bool { L10n.shared.language == "my" }
    internal enum Navigation {
        internal enum Bar {
            internal enum Item {
                internal static var cancel: String { "navigation.bar.item.cancel".l10n() }
                internal static var done: String { "navigation.bar.item.done".l10n() }
                internal static var back: String { "navigation.bar.item.back".l10n() }
            }
        }
        internal enum Title {
            internal static var home: String { "navigation.title.home".l10n() }
            internal static var my_stuffs: String { "navigation.title.my-stuffs".l10n() }
            internal static var post: String { "navigation.title.post".l10n() }
            internal static var services: String { "navigation.title.services".l10n() }
            internal static var settings: String { "navigation.title.settings".l10n() }
        }
    }

    internal enum Screen {
        internal enum Settings {
            internal enum Form {
                internal static var name: String { "screen.settings.form.name".l10n() }
                internal static var email: String { "screen.settings.form.email".l10n() }
                internal static var phone: String { "screen.settings.form.phone".l10n() }
                internal static var profile_settings: String { "screen.settings.form.profile-settings".l10n() }
                internal static var appearance_settings: String { "screen.settings.form.appearance-settings".l10n() }
                internal static var open_device_settings: String { "screen.settings.form.open-device-settings".l10n() }
                internal static var developer_controls: String { "screen.settings.form.developer-controls".l10n() }
                internal static var terms_and_conditions: String { "screen.settings.form.terms-and-conditions".l10n() }
                internal static var onboarding_tutorials: String { "screen.settings.form.onboarding-tutorials".l10n() }
                internal static var contact_us: String { "screen.settings.form.contact-us".l10n() }
                internal static var reset_settings: String { "screen.settings.form.reset-settings".l10n() }
            }
        }
    }
}
