//
//  PostFormView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/6/23.
//

import SwiftUI
import XUI

struct PostForm_Details: View {
    
    @EnvironmentObject private var post: Post
    @Environment(PostingFlowRouter.self) private var router
    @MainActor
    var body: some View {
        Form {
            Section {
                Group {
                    XNavPickerBar("Property Type", PropertyType.allCases, $post.propertyType)
                    XNavPickerBar("Room Type", RoomType.allCases, $post._roomType)
                        ._hidable(post.category != .rental_room)
                    XNavPickerBar("Tenant Type", TenantType.allCases, $post._tenantType)
                        ._hidable(post.category != .rental_room)
                    XNavPickerBar("Occupant", Occupant.allCases, $post._occupant)
                        ._hidable(post.category != .rental_room)
                }
                Group {
                    XNavPickerBar("Lease Term", LeaseTerm.allCases, $post._leaseTerm)
                        ._hidable(post.category == .selling)
                    XNavPickerBar("Furnishing", Furnishing.allCases, $post._furnishing)
                        ._hidable(post.category == .selling)
                    XNavPickerBar("Floor Level", FloorLevel.allCases, $post.floorLevel)
                    XNavPickerBar("Tenure", Tenure.allCases, $post._tenure)
                        ._hidable(post.category != .selling)
                    XNavPickerBar("Beds", Bedroom.allCases, $post.beds)
                    XNavPickerBar("Bathroom", Bathroom.allCases, $post.baths)
                }
                Group {
                    DatePicker(
                        "Available Date",
                        selection: $post.availableDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.automatic)
                    .environment(\.locale, Locale.current)
                }
            } header: {
                Text("Please fill up the following details")
            }
            
            Section("Features") {
                GridMultiPicker(source: Feature.allCases, selection: $post.features)
                    .listRowInsets(.init())
            }
            .listRowBackground(Color.clear)
            
            Section("Restrictions") {
                GridMultiPicker(source: Restriction.allCases, selection: $post.restrictions)
                    .listRowInsets(.init())
            }
            .listRowBackground(Color.clear)
            
        }
        .navigationTitle("@details")
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    router.path.append(.description)
                } label: {
                    Text("next \(Image(systemSymbol: .arrowshapeForwardFill))")
                }
                .disabled(!isValid())
            }
        }
    }
    
    private func isValid() -> Bool {
        switch post.category {
        case .rental_flat:
            return post.propertyType != .Any && post.leaseTerm != .Any && post.furnishing != .Any && post.floorLevel != .Any && post.beds != .Any && post.baths != .Any
        case .rental_room:
            return post.propertyType != .Any && post.roomType != .Any && post.tenantType != .Any && post.occupant != .Any && post.occupant != .Any && post.leaseTerm != .Any
        case .selling:
            return post.propertyType != .Any && post.tenure != .Any && post.floorLevel != .Any && post.baths != .Any && post.beds != .Any && post.tenure != .Any
        }
    }
}
