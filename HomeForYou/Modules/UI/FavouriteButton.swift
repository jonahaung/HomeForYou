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
            if isFavourite {
                _Haptics.play(.rigid)
            }
            try await Repo.shared.async_add(post)
        } label: {
            SystemImage(isFavourite ? .handThumbsupFill : .handThumbsup, isFavourite ? 34 : 25)
                .foregroundStyle(isFavourite ? Color.accentColor.gradient : Color.secondary.gradient)
                .padding()
        }
        .withReactionAnimation(isFavourite)
    }
    var isFavourite: Bool { post.favourites.contains(currentUser.uid) }
}
