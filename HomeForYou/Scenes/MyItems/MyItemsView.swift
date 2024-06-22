//
//  ServicesView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 19/2/23.
//

import SwiftUI
import XUI
import FireAuthManager

struct MyItemsView: View {

    @Environment(CurrentUser.self) private var currentUser
    @Injected(\.ui) private var ui

    var body: some View {
        List {
            Section {
                LottieView(lottieFile: "network", isJson: true, contentMode: .scaleAspectFill)
                    .aspectRatio(1.3, contentMode: .fill)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear.hidden())
            .listRowInsets(.init())

            if let person = currentUser.model {
                Section {
                    ListRowLabel(.checklist, "My Listings")
                        .routeToPosts(PostQuery(.autherID, person.id))

                    ListRowLabel(.handThumbsup, "My Favourites")
                        .routeToPosts(PostQuery(.favourites, person.id))

                    ListRowLabel(.shoeprintsFill, "My Seen Posts")
                        .routeToPosts(PostQuery(.views, person.id))

                    ListRowLabel(.aMagnify, "My Search History")
                        .routable(to: .init(.developerControl))
                } footer: {
                    Text(Lorem.tweet)
                }
            }
        }
    }
}
