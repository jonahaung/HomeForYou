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
                .phaseAnimation([.idle, .scale(1.5)], isFavourite)
                .symbolVariant(isFavourite ? .fill : .none)
                .padding()
        }
    }
    private var isFavourite: Bool { post.favourites.contains(currentUser.uid) }
}
