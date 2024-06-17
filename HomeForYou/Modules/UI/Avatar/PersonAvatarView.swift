//
//  PersonAvatarView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/4/23.
//

import SwiftUI
import XUI

struct PersonAvatarView: View, Sendable {
    
    let personInfo: PersonInfo
    let size: CGFloat
    var showBadge: Bool = true
    
    var body: some View {
        AvatarView(urlString: personInfo.photoURL.str, size: size)
            ._presentSheet {
                PersonDetailsView(model: personInfo)
            }
    }
}
private struct BadgeModifier<Badge: View>: ViewModifier {
    let alignment: SwiftUI.Alignment
    @ViewBuilder var badge: (() -> Badge)
    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment) {
                badge()
            }
    }
}
extension AvatarView {
    func avatarBadge<Badge: View>(alignment: SwiftUI.Alignment = .bottomTrailing, @ViewBuilder _ badge: @escaping @Sendable () -> Badge) -> some View {
        ModifiedContent(content: self, modifier: BadgeModifier(alignment: alignment, badge: badge))
    }
}
