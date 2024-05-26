//
//  Color.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/6/23.
//

import SwiftUI

extension Color {
    static let systemBackground: Color = Color(uiColor: .systemBackground)
    struct Theme {
        static let blue = Color("theme_blue")
        static let pink = Color("theme_pink")
        static let green = Color("theme_green")
        static let green_1 = Color("theme_green 1")
        static let green_2 = Color("theme_green 2")
        static let yellow = Color("theme_yellow")
        static let purple = Color("theme_purple")
        static let teal = Color("theme_teal")
        static let orange = Color("theme_orange")
        static let orange_1 = Color("theme_orange 1")
        static let orange_2 = Color("theme_orange 2")
        static let red = Color("theme_red")
        static let copper = Color("theme_copper")

        static var all: [Color] {
            [Theme.blue, Theme.pink, Theme.green, Theme.green_1, Theme.green_2, Theme.yellow, Theme.purple, Theme.teal, Theme.orange, Theme.orange_1, Theme.orange_2, Theme.red, Theme.copper]
        }

        static var random: Color { all.random() ?? .accentColor }
    }

    struct Background {
        static let _0 = Color("background")
        static let _1 = Color("background 1")
        static let _2 = Color("background 2")
        static let _3 = Color("background 3")
        static let _4 = Color("background 4")
        static let _5 = Color("background 5")
    }

    struct Soft {
        static let blue = Color("bg_blue")
        static let blue_1 = Color("bg_blue 1")
        static let green = Color("bg_green")
        static let orange = Color("bg_orange")
        static let pink = Color("bg_pink")
        static let white = Color("bg_white")
        static let yellow = Color("bg_yellow")
        static let shadow = Color("shadow")

        static var all: [Color] { [Soft.blue, Soft.blue_1, Soft.green, Soft.orange, Soft.pink, Soft.white, Soft.yellow, Soft.shadow] }
        static var random: Color { all.random() ?? .accentColor }
    }
}
