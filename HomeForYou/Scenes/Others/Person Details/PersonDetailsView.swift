//
//  PersonDetailsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/4/23.
//

import SwiftUI
import XUI

struct PersonDetailsView: View {

    @State var model: PersonInfo

    var body: some View {
        List {
            Section {
                AvatarView(urlString: model.photoURL.str, size: 65)
            } footer: {
                RatingView(.constant(2.5))
            }
            Text(model.name.str)
        }
    }
}
