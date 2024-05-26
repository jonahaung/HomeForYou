//
//  SearchingModel.swift
//  HomeForYou
//  Created by Aung Ko Min on 3/8/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI
import XUI

enum Searching {
    struct Response: Hashable, Identifiable {
        var id: String { keyword.id }
        var attributedString: AttributedString
        var keyword: KeyWord
    }
}
