//
//  CollectableTextView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/6/23.
//

import SwiftUI

struct CollapsableText: View {
    let text: String
    var limit: Int = 2
    @State private var isCollapsed = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .lineLimit(isCollapsed ? nil : limit)
            HStack {
                Spacer()
                Button {
                    isCollapsed.toggle()
                } label: {
                    Text("more")
                        .font(.caption)
                        .italic()
                        .foregroundColor(.accentColor)
                }
                ._hidable(isCollapsed)
            }
        }
        .animation(.easeIn(duration: 0.4), value: isCollapsed)
    }
}
