//
//  HomeCategorySection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import XUI

struct HomeCategorySection: View {
    var body: some View {
        InsetGroupSection(16) {
            CategoryPicker()
                .pickerStyle(.inline)
        } footer: {
            Text(Home.Category_Text)
        }
    }
}
