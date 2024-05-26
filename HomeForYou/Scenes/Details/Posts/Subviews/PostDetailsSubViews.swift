//
//  AttachmentSection.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/4/23.
//

import SwiftUI
import XUI
import SFSafeSymbols
import FireAuthManager

struct PostDetailsSections {
    
    // Other Details
    struct OtherDetailsSection: View {
        @EnvironmentObject private var post: Post
        var body: some View {
            Section {
                _FormCell {
                    Text("Property Type")
                } right: {
                    Text(.init(post.propertyType.title))
                        .routeToPosts([.init(.propertyType, [post.propertyType.rawValue])])
                        .fixedSize()
                }
                
                _FormCell {
                    Text("Lease Term")
                } right: {
                    Text(.init(post._leaseTerm.title))
                        .routeToPosts([.init(.leaseTerm, [post._leaseTerm.rawValue])])
                        .fixedSize()
                }
                ._hidable(post.category == .selling)
                
                _FormCell {
                    Text("Furnishing")
                } right: {
                    Text(.init(post._furnishing.title))
                        .routeToPosts([.init(.furnishing, [post._furnishing.rawValue])])
                        .fixedSize()
                }
                ._hidable(post.category == .selling)
                
                _FormCell {
                    Text("Floor Level")
                } right: {
                    Text(.init(post.floorLevel.title))
                        .routeToPosts([.init(.floorLevel, [post.floorLevel.rawValue])])
                        .fixedSize()
                }
                
                _FormCell {
                    Text("Tenant Type")
                } right: {
                    Text(.init(post._tenantType.title))
                        .routeToPosts([.init(.tenantType, [post._tenantType.rawValue])])
                        .fixedSize()
                }
                ._hidable(post.category == .selling)
                
                _FormCell {
                    Text("Occupant")
                } right: {
                    Text(.init(post._occupant.title))
                        .routeToPosts([.init(.occupant, [post._occupant.rawValue])])
                        .fixedSize()
                }
                ._hidable(post.category == .selling)
                
                _FormCell {
                    Text("Tenure")
                } right: {
                    Text(.init(post._tenure.title))
                        .routeToPosts([.init(.tenure, [post._tenure.rawValue])])
                        .fixedSize()
                }
                ._hidable(post.category != .selling)
                
                _FormCell {
                    Text("Bed Rooms")
                } right: {
                    Text(.init(post.beds.title))
                        .routeToPosts([.init(.beds, [post.beds.rawValue])])
                        .fixedSize()
                }
                
                _FormCell {
                    Text("Bath Rooms")
                } right: {
                    Text(.init(post.baths.title))
                        .routeToPosts([.init(.baths, [post.baths.rawValue])])
                        .fixedSize()
                }
                
                DatePicker(selection: .constant(post.availableDate), displayedComponents: .date) {
                    Text("Available from")
                }
                .datePickerStyle(.compact)
            }
        }
    }
    
    // Keywords
    struct KeyWordsSection: View {
        
        @EnvironmentObject private var post: Post
        var body: some View {
            Section {
                VStack {
                    WrappedStack(.vertical) {
                        ForEach(post._keyWords) { keyword in
                            _Tag {
                                Text(keyword.localizedString)
                            }
                            .foregroundColor(.primary)
                            .routeToPosts([.init(.keywords, [keyword.keyValueString])])
                        }
                    }
                }
                .padding(2)
            } header: {
                Text("Keynotes")
            }
            .listRowBackground(EmptyView())
            .listRowInsets(.init())
        }
    }
    
    // Author
    struct AuthorSection: View {
        @EnvironmentObject private var post: Post
        var body: some View {
            Section {
                let author = post.author
                Group {
                    HStack {
                        PersonAvatarView(personInfo: author, size: 60)
                            .padding(.trailing)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(author.name.str)
                                .routeToPosts([.init(.autherID, [author.id])])
                            Text("Member since ")
                                .italic()
                                .font(.footnote)
                            //                            +
                            //                            Text(postDetails.utils.dateFormatter.string(from: author.metaData?.creationDate ?? .now))
                        }
                    }
                    Text(.init("More posts from *\(author.name.str)*"))
                        ._navigationLinkStyle()
                        .routeToPosts([.init(.autherID, [author.id])])
                }
            } header: {
                Text("Author")
            }
        }
        
    }
    
    // Address
    struct AddressSection: View {
        
        @EnvironmentObject private var post: Post
        
        var body: some View {
            Section {
                LocationMap([post.locationMapItem])
                    .frame(height: 250)
                    .listRowInsets(.init())
                
                _FormCell {
                    Text("Postal Code")
                } right: {
                    Text(post._location.address.postal)
                        .routeToPosts([.init(.keywords, [KeyWord(.postal, post.postalCode).keyValueString])])
                }
                _FormCell {
                    Text("Area")
                } right: {
                    Text(.init(post._location.area.title))
                        .routeToPosts([.init(.area, [post._location.area.rawValue])])
                }
                _FormCell {
                    Text("Nearest MRT")
                } right: {
                    Text(post._location.nearestMRT.mrt)
                        .routeToPosts([.init(.mrt, [post._location.nearestMRT.mrt])])
                }
                _FormCell {
                    Text("Location Identifier")
                } right: {
                    Text(post._location.geoInfo.geoHash)
                        .routeToPosts([.init(.geoHash, [post._location.geoInfo.geoHash])])
                }
            } header: {
                Text(post._location.address.text)
            } footer: {
                Text("\(post._location.nearestMRT.distance) minutes walk from \(post.mrt) MRT ")
            }
        }
    }
    
    // Features & Restrictions
    struct FeaturesAndRestrictionsSection: View {
        @EnvironmentObject private var post: Post
        var body: some View {
            Section {
                VStack {
                    WrappedStack(.vertical) {
                        ForEach(post.features) { value in
                            _Tag {
                                Text(value.title)
                            }
                            .foregroundColor(.primary)
                            .routeToPosts([.init(.features, [value.rawValue])])
                        }
                    }
                    WrappedStack(.vertical) {
                        ForEach(post.restrictions) { value in
                            _Tag {
                                Text(value.title)
                            }
                            .foregroundColor(.primary)
                            .routeToPosts([.init(.restrictions, [value.rawValue])])
                        }
                    }
                }.padding(2)
                
            } header: {
                Text("Features & Restrictions")
            }
            .listRowBackground(EmptyView())
            .listRowInsets(.init())
        }
    }
    
    // Description
    struct DescriptionSection: View {
        @EnvironmentObject private var post: Post
        @Injected(\.utils) private var utils
        @Injected(\.ui) private var ui
        
        var body: some View {
            Section {
                Text(.init(post.description))
                    .font(ui.fonts.callOut)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Description")
            } footer: {
                _IconLabel(symbol: .calendar, "Posted: \(utils.timeAgoFormatter.string(from: post.createdAt)) ago")
            }
        }
    }
    
    // Views & Favourites
    struct ViewsAndFavouritesSection: View {
        @EnvironmentObject private var post: Post
        var body: some View {
            Section {
                DisclosureGroup {
                    ForEach(post.favourites, id: \.self) {
                        PersonCell($0)
                    }
                } label: {
                    Text("Favourites")
                        .badge(post.favourites.count)
                }
                
                DisclosureGroup {
                    ForEach(post.views, id: \.self) {
                        PersonCell($0)
                    }
                } label: {
                    Text("Views")
                        .badge(post.views.count)
                }
                
                Text("Similier Items")
                    ._navigationLinkStyle()
                    .routeToPosts([.init(.propertyType, [post.propertyType.rawValue]), .init(.roomType, [post._roomType.rawValue]), .init(.status, [post.status.rawValue])])
            }
        }
    }
    
    // Actions
    struct ActionSection: View {
        
        @EnvironmentObject private var post: Post
        @Injected(\.utils) private var utils
        @Environment(\.dismiss) private var dismiss
        @Injected(\.currentUser) private var currentUser
        
        var body: some View {
            Section {
                Text("Report Sparm")
                    ._presentSheet {
                        Text("Sparm")
                    }
                if post.autherID == currentUser.uid {
                    Text("Edit Post")
                        .presentable(.init(.createPost, data: post), .fullScreenCover)
                    Text("Delete Post Permanently")
                        ._comfirmationDialouge {
                            Button(role: .destructive) {
                                Repo.delete(post) {_ in
                                    self.dismiss()
                                }
                            } label: {
                                Text("Continue Delete")
                            }
                        }
                }
            }
        }
    }
    
    // Contacts Toolbar
    struct PostDetailsContactsToolbar: View {
        @EnvironmentObject private var post: Post
        var body: some View {
            HStack {
                Spacer()
                Group {
                    LinkButton(.phoneCall(post.phoneNumber)) {
                        SystemImage(.phone, 44)
                    }
                    LinkButton(.sms(post.phoneNumber)) {
                        SystemImage(.message, 44)
                    }
                    LinkButton(.email(post.author.email.str)) {
                        SystemImage(.envelope, 44)
                    }
                }
                .symbolRenderingMode(.multicolor)
                .symbolVariant(.circle.fill)
                
                LinkButton(.whatsapp(phoneNumber: post.phoneNumber, message: "Hi, regarding \(post.title.capitalized).")) {
                    Image("whatsapp")
                        .resizable()
                        .frame(square: 44)
                }
                Spacer()
            }
        }
    }
}
