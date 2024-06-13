//
//  FavouriteButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/2/23.
//

import SwiftUI
import XUI
import FireAuthManager

struct FavouriteButton: View {
    
    @EnvironmentObject private var post: Post
    @Injected(\.router) private var router
    @Injected(\.currentUser) private var currentUser
    
    var body: some View {
        AsyncButton {
            guard currentUser.isLoggedIn else {
                router.presentSheet(.init(.signIn))
                return
            }
            
            var favourites = post.favourites
            
            if isFavourite {
                favourites.removeAll { $0 == currentUser.uid }
            } else {
                favourites.append(currentUser.uid)
            }
            post.favourites = favourites
            try await Repo.shared.async_add(post)
        } label: {
            SystemImage(.handThumbsup, 25)
                .symbolVariant(isFavourite ? .fill : .none)
                .padding()
        }.keyframeAnimator(
            initialValue: AnimationValues(),
            trigger: isFavourite
        ) { content, value in
            content
                .rotationEffect(value.angle)
                .scaleEffect(value.scale)
                .scaleEffect(y: value.verticalStretch)
                .offset(y: value.verticalOffset)
        } keyframes: { _ in
            KeyframeTrack(\.scale) {
                LinearKeyframe(1.0, duration: 0.36)
                SpringKeyframe(1.5, duration: 0.8, spring: .bouncy)
                SpringKeyframe(1.0, spring: .bouncy)
            }
            
            KeyframeTrack(\.verticalOffset) {
                LinearKeyframe(0.0, duration: 0.1)
                SpringKeyframe(20.0, duration: 0.15, spring: .bouncy)
                SpringKeyframe(-60.0, duration: 1.0, spring: .bouncy)
                SpringKeyframe(0.0, spring: .bouncy)
            }

            KeyframeTrack(\.verticalStretch) {
                CubicKeyframe(1.0, duration: 0.1)
                CubicKeyframe(0.6, duration: 0.15)
                CubicKeyframe(1.5, duration: 0.1)
                CubicKeyframe(1.05, duration: 0.15)
                CubicKeyframe(1.0, duration: 0.88)
                CubicKeyframe(0.8, duration: 0.1)
                CubicKeyframe(1.04, duration: 0.4)
                CubicKeyframe(1.0, duration: 0.22)
            }

            KeyframeTrack(\.angle) {
                CubicKeyframe(.zero, duration: 0.58)
                CubicKeyframe(.degrees(16), duration: 0.125)
                CubicKeyframe(.degrees(-16), duration: 0.125)
                CubicKeyframe(.degrees(16), duration: 0.125)
                CubicKeyframe(.zero, duration: 0.125)
            }
        }
    }
    private var isFavourite: Bool { post.favourites.contains(currentUser.uid) }
}
private struct AnimationValues {
    var scale = 1.0
    var verticalStretch = 1.0
    var verticalOffset = 0.0
    var angle = Angle.zero
}
