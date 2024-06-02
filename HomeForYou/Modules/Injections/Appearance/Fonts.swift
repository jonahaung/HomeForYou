//
//  Fonts.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import SwiftUI
import NaturalLanguage
import L10n_swift

internal struct Fonts: Equatable {

    internal enum MyanmarFont: String {
        case sanPro = "MyanmarSansPro"
        case nwayOo = "MasterpieceSpringRev"
        case notoSans = "NotoSansMyanmar"

        static let sanProFont = UIFont(name: Self.sanPro.rawValue, size: UIFont.systemFontSize)!
        static let nwayOoFont = UIFont(name: Self.nwayOo.rawValue, size: UIFont.systemFontSize)!
        static let notoSansFont = UIFont(name: Self.notoSans.rawValue, size: UIFont.systemFontSize)!
    }

    var caption1 = Font.caption
    var caption2 = Font.caption2
    var footnote = Font.footnote
    var subheadline = Font.subheadline
    var callOut = Font.callout
    var body = Font.body
    var headline = Font.headline
    var title = Font.title
    var title2 = Font.title2
    var title3 = Font.title3
    var largeTitle = Font.largeTitle

    init() {
        if L10n.shared.language == "my" {
            let font = MyanmarFont.sanProFont
            let fontName = MyanmarFont.sanPro.rawValue
            headline = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
            body = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .body).pointSize)
            callOut = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
            subheadline = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
            footnote = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
            caption1 = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
            caption2 = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .caption2).pointSize)
            title = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
            title2 = .custom(fontName, size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
            largeTitle = .custom(MyanmarFont.nwayOo.rawValue, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)

            UILabel.appearance().substituteFontName = fontName
            UITextField.appearance().substituteFontName = fontName
            UITextView.appearance().substituteFontName = fontName
            UILabel.appearance().font = UIFont(name: fontName, size: UIFont.systemFontSize)
            [UIControl.State.normal, .application, .disabled, .focused, .highlighted, .reserved].forEach { state in
                UIBarButtonItem.appearance().setTitleTextAttributes([.font: MyanmarFont.sanProFont.withSize(UIFont.buttonFontSize)], for: state)
            }
            UILabel.appearance().font = font.withSize(UIFont.labelFontSize)
            UINavigationBar.appearance().titleTextAttributes = [.font: MyanmarFont.sanProFont.withSize(UIFont.labelFontSize)]
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: MyanmarFont.nwayOoFont.withSize(UIFont.preferredFont(forTextStyle: .largeTitle).pointSize + 1)]
        }
    }
}

private extension UILabel {
    @objc var substituteFontName: String {
        get { return self.font.fontName }
        set {
            self.font = UIFont(name: newValue, size: self.font.pointSize)
        }
    }
}

private extension UITextField {
    @objc var substituteFontName: String {
        get { return self.font!.fontName }
        set { self.font = UIFont(name: newValue, size: (self.font?.pointSize)!) }
    }
}
private extension UITextView {
    @objc var substituteFontName: String {
        get { return self.font!.fontName }
        set { self.font = UIFont(name: newValue, size: (self.font?.pointSize)!) }
    }
}
