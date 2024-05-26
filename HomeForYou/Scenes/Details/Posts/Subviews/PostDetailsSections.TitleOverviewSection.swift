//
//  PostDetailsSections.TitleSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 4/8/23.
//

import SwiftUI
import XUI

extension PostDetailsSections {

    struct TitleOverviewSection: View {

        @EnvironmentObject private var post: Post
        @Injected(\.utils) private var utils
        @Injected(\.ui) private var ui

        var body: some View {
            Section {
                Text(post.title)
                    .font(ui.fonts.headline)

                Divider()
                HStack {
                    Text(post.getPostCaption())
                        .font(ui.fonts.callOut)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("$\(utils.kmbFormatter.string(fromNumber: post.price))")
                        .font(ui.fonts.title)
                }

                Divider()
                    .padding(.horizontal)

                Grid(alignment: .leading, verticalSpacing: 10) {
                    GridRow {
                        // Prooperty Type
                        _IconLabel(symbol: .building2CropCircleFill, post.propertyType.rawValue)
                            .routeToPosts([.init(.propertyType, [post.propertyType.rawValue])])
                        Spacer()
                        switch post.category {
                        case .rental_room:
                            Text(.init(post._roomType.title.appending(" Room")))
                                .routeToPosts([.init(.roomType, [post._roomType.rawValue])])
                        case .rental_flat:
                            Text(.init(post._leaseTerm.title.appending(" Lease")))
                                .routeToPosts([.init(.leaseTerm, [post._leaseTerm.rawValue])])
                        case .selling:
                            Text(.init(post._tenure.title.appending(" Tenure")))
                                .routeToPosts([.init(.tenure, [post._tenure.rawValue])])
                        }
                    }
                    GridRow {
                        // Area
                        _IconLabel(symbol: .mappinCircleFill, post.area.title)
                            .routeToPosts([.init(.area, [post.area.rawValue])])

                        Spacer()
                        // MRT
                        _IconLabel(symbol: .tramCircleFill, post.mrt)
                            .routeToPosts([.init(.mrt, [post.mrt])])
                    }
                }
            }
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            .listRowBackground(EmptyView())
        }
    }
}
