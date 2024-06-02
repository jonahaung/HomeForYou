//
//  HomeNearbyPostsScetion.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/5/24.
//

import SwiftUI
import XUI
import Combine

struct HomeNearbyPostsScetion: View {
    
    @EnvironmentObject private var nearbyLocationHandler: NearbyLocationHandler
    
    var body: some View {
        InsetGroupSection {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    if nearbyLocationHandler.nearbyPosts.isEmpty {
                        ForEach(Post.mock(for: 6)) { each in
                            PostHCell()
                                .environmentObject(each)
                                .redacted(reason: .placeholder)
                        }
                    } else {
                        ForEach(nearbyLocationHandler.nearbyPosts) { each in
                            PostHCell()
                                .environmentObject(each)
                        }
                    }
                }
            }
            .transition(.opacity.animation(.bouncy))
            .frame(height: 170.scaled)
            .showLoading(nearbyLocationHandler.loading)
            .alertPresenter($nearbyLocationHandler.alert)
        } header: {
            if let location = nearbyLocationHandler.location {
                HomeSectionHeaderView(
                    "Nearby Posts",
                    .locationFill,
                    [.init(.geoHash, [location.geoInfo.geoHash])]
                )
            }
        } footer: {
            VStack {
                if let location = nearbyLocationHandler.location {
                    Label(location.address.text, systemSymbol: .mappinAndEllipse)
                        .font(.system(size: 14.scaled, weight: .semibold).italic())
                }
//                NearbyLocationMap(items: nearbyLocationHandler.nearbyPosts, currentLocation: $nearbyLocationHandler.currentLocation)
//                    .aspectRatio(1.5, contentMode: .fit)
            }
        }
        
//        .appPermissionOverlay(.currentLocation)
    }
}
