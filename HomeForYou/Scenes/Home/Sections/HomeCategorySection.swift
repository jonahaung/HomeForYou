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
                .pickerStyle(.segmented)
        } footer: {
            let text = """
Firebase In-App Messaging API has not been used in project 39338351827 before or it is disabled. Enable it by visiting com.jonahaung.homeforyou://post?id=5.930499481731119e-13&collectionPath=posts_rental_room
Firebase In-App Messaging API has not been used in project 39338351827 before or it is disabled. Enable it by visiting com.jonahaung.homeforyou://post?id=5.930499481731119e-13&collectionPath=posts_rental_room
"""
            Text(text)
        }
    }
}
