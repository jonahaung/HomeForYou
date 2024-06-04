//
//  GroupSectionList.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/6/24.
//

import SwiftUI

public struct InsetGroupList<Content: View>: View {
    private let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Group {
                content()
            }
            .padding(
                EdgeInsets(
                    top: 10.scaled,
                    leading: 18.scaled,
                    bottom: 10.scaled,
                    trailing: 10.scaled
                )
            )
            .background(alignment: .bottom) {
                Divider()
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: 20.scaled,
                            bottom: 0,
                            trailing: 8.scaled)
                    )
            }
        }
        .background(Color.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12.scaled))
        .compositingGroup()
        .padding()
    }
}
