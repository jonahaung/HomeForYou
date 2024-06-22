//
//  PostView.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
// s

import SwiftUI
import XUI
import FireAuthManager
struct PostingMenuView: View {

    @Injected(\.currentUser) private var currentUser
    @Injected(\.ui) private var ui
    @EnvironmentObject private var alert: AlertManager

    var body: some View {
        List {
            Section {
                Text("Free listing, no success fees, no hidden fees")
                    .font(ui.fonts.headline)
            } header: {
                LottieView(lottieFile: "house_countryside", isJson: true, contentMode: .scaleAspectFit)
                    .aspectRatio(1.5, contentMode: .fit)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear.hidden())
            .listRowInsets(.init())

            if let user = currentUser.model {
                Section {
                    ListRowLabel(alignment: .leading, .building2, "I Would Like to Sell My Property")
                        .presentable(.init(.createPost, data: Post(category: .selling, author: user)), .fullScreenCover)
                    ListRowLabel(alignment: .leading, .house, "I Would Like to Rent My Property")
                        .presentable(.init(.createPost, data: Post(category: .rental_flat, author: user)), .fullScreenCover)
                    ListRowLabel(alignment: .leading, .bedDouble, "I Would Like to Rent My Room")
                        .presentable(.init(.createPost, data: Post(category: .rental_room, author: user)), .fullScreenCover)
                } footer: {
                    Text(Lorem.tweet)
                }
            }
            
        
            Section {
                DisclosureGroup {
                    ListRowLabel(alignment: .leading, .dollarsignCircle, "Buying a Property")
                        .presentable(.init(.createPostLooking, data: Category.selling), .fullScreenCover)
                    ListRowLabel(alignment: .leading, .building2CropCircle, "Renting a Property")
                        .presentable(.init(.createPostLooking, data: Category.rental_flat), .fullScreenCover)
                    ListRowLabel(alignment: .leading, .bedDoubleCircle, "Renting a Room")
                        .presentable(.init(.createPostLooking, data: Category.rental_room), .fullScreenCover)
                } label: {
                    ListRowLabel(alignment: .leading, .magnifyingglass, "I'm Looking For")
                }
            } footer: {
                Text(Lorem.tweet)
            }

            Section {
                Text("Need help with your property? Talk to our profesional property agents.")
                    .font(ui.fonts.subheadline)
                HStack {
                    Button {

                    } label: {
                        SystemImage(.message)
                            .symbolVariant(.fill)
                    }
                    Button {

                    } label: {
                        SystemImage(.phone)
                            .symbolVariant(.fill)
                    }
                    Button {

                    } label: {
                        SystemImage(.envelope)
                            .symbolVariant(.fill)
                    }
                }
                .imageScale(.large)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear.hidden())
        }
        .navigationBarItems(leading: leadingItem, trailing: trailingItem)
    }

    private var leadingItem: some View {
        Button {

        } label: {
            SystemImage(.questionmarkCircleFill)
                .symbolRenderingMode(.multicolor)
        }
    }

    private var trailingItem: some View {
        Button {
        } label: {
            SystemImage(.bellBadgeFill)
                .symbolRenderingMode(.multicolor)
        }
    }
}
import FirebaseAuth
extension CurrentUser {
    var model: Person? {
        if let user = Auth.auth().currentUser {
            return .init(user: user)
        }
        return nil
    }
}
