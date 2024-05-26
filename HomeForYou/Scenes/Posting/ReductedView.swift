//
//  ReductedView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/7/23.
//

import SwiftUI
import XUI

struct ReductedView: View {

    let text = Lorem.tweet

    var body: some View {
        List {
            Section {
                ForEach(0...3) { _ in
                    Text(text)
                }

                ForEach(0...4) { _ in
                    Text(text)
                }

                ForEach(0...2) { _ in
                    Text(text)
                }

                ForEach(0...4) { _ in
                    Text(text)
                }
            }
        }
        .navigationTitle("Title")
        .navigationBarItems(leading: _DismissButton())
        .redacted(reason: [.placeholder])
    }
}
