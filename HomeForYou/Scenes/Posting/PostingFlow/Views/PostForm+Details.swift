//
//  PostFormView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/6/23.
//

import SwiftUI
import XUI

struct PostForm_Details: View {
    
    @Binding var postingData: MutablePost
    @Environment(PostingFlowRouter.self) private var router
    @MainActor
    var body: some View {
        Form {
            Section {
                Group {
                    XNavPickerBar("Property Type", PropertyType.allCases, $postingData.propertyType)
                    XNavPickerBar("Room Type", RoomType.allCases, $postingData._roomType)
                        ._hidable(postingData.category != .rental_room)
                    XNavPickerBar("Tenant Type", TenantType.allCases, $postingData._tenantType)
                        ._hidable(postingData.category != .rental_room)
                    XNavPickerBar("Occupant", Occupant.allCases, $postingData._occupant)
                        ._hidable(postingData.category != .rental_room)
                }
                Group {
                    XNavPickerBar("Lease Term", LeaseTerm.allCases, $postingData._leaseTerm)
                        ._hidable(postingData.category == .selling)
                    XNavPickerBar("Furnishing", Furnishing.allCases, $postingData._furnishing)
                        ._hidable(postingData.category == .selling)
                    XNavPickerBar("Floor Level", FloorLevel.allCases, $postingData.floorLevel)
                    XNavPickerBar("Tenure", Tenure.allCases, $postingData._tenure)
                        ._hidable(postingData.category != .selling)
                    XNavPickerBar("Beds", Bedroom.allCases, $postingData.beds)
                    XNavPickerBar("Bathroom", Bathroom.allCases, $postingData.baths)
                }
                Group {
                    DatePicker(
                        "Available Date",
                        selection: $postingData.availableDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.automatic)
                    .environment(\.locale, Locale.current)
                }
            } header: {
                Text("Please fill up the following details")
            }
            
            Section("Features") {
                GridMultiPicker(source: Feature.allCases, selection: $postingData.features)
                    .listRowInsets(.init())
            }
            .listRowBackground(Color.clear)
            
            Section("Restrictions") {
                GridMultiPicker(source: Restriction.allCases, selection: $postingData.restrictions)
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
        switch postingData.category {
        case .rental_flat:
            return postingData.propertyType != .Any && postingData.leaseTerm != .Any && postingData.furnishing != .Any && postingData.floorLevel != .Any && postingData.beds != .Any && postingData.baths != .Any
        case .rental_room:
            return postingData.propertyType != .Any && postingData.roomType != .Any && postingData.tenantType != .Any && postingData.occupant != .Any && postingData.occupant != .Any && postingData.leaseTerm != .Any
        case .selling:
            return postingData.propertyType != .Any && postingData.tenure != .Any && postingData.floorLevel != .Any && postingData.baths != .Any && postingData.beds != .Any && postingData.tenure != .Any
        }
    }
}
