//
//  PostFormView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/6/23.
//

import SwiftUI
import XUI

struct PostForm_Details<T: Postable>: View {
    
    @Binding private var editablePost: T
    
    init(_ editablePost: Binding<T>) {
        self._editablePost = editablePost
    }
    
    var body: some View {
        Form {
            Section {
                Group {
                    XNavPickerBar("Property Type", PropertyType.allCases, $editablePost.propertyType)
                    XNavPickerBar("Room Type", RoomType.allCases, $editablePost._roomType)
                        ._hidable(editablePost.category != .rental_room)
                    XNavPickerBar("Tenant Type", TenantType.allCases, $editablePost._tenantType)
                        ._hidable(editablePost.category != .rental_room)
                    XNavPickerBar("Occupant", Occupant.allCases, $editablePost._occupant)
                        ._hidable(editablePost.category != .rental_room)
                }
                Group {
                    XNavPickerBar("Lease Term", LeaseTerm.allCases, $editablePost._leaseTerm)
                        ._hidable(editablePost.category == .selling)
                    XNavPickerBar("Furnishing", Furnishing.allCases, $editablePost._furnishing)
                        ._hidable(editablePost.category == .selling)
                    XNavPickerBar("Floor Level", FloorLevel.allCases, $editablePost.floorLevel)
                    XNavPickerBar("Tenure", Tenure.allCases, $editablePost._tenure)
                        ._hidable(editablePost.category != .selling)
                    XNavPickerBar("Beds", Bedroom.allCases, $editablePost.beds)
                    XNavPickerBar("Bathroom", Bathroom.allCases, $editablePost.baths)
                }
                Group {
                    DatePicker(
                        "Available Date",
                        selection: $editablePost.availableDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.automatic)
                    .environment(\.locale, Locale.current)
                }
            } header: {
                Text("Please fill up the following details")
            }
            
            Section("Features") {
                GridMultiPicker(source: Feature.allCases, selection: $editablePost.features)
                    .listRowInsets(.init())
            }
            .listRowBackground(Color.clear)
            
            Section("Restrictions") {
                GridMultiPicker(source: Restriction.allCases, selection: $editablePost.restrictions)
                    .listRowInsets(.init())
            }
            .listRowBackground(Color.clear)
            
        }
        .navigationTitle("@details")
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Text("next \(Image(systemSymbol: .arrowshapeForwardFill))")
                    ._tapToPush {
                        PostForm_Description($editablePost)
                    }
                .disabled(!isValid())
            }
        }
    }
    
    private func isValid() -> Bool {
        switch editablePost.category {
        case .rental_flat:
            return editablePost.propertyType != .Any && editablePost.leaseTerm != .Any && editablePost.furnishing != .Any && editablePost.floorLevel != .Any && editablePost.beds != .Any && editablePost.baths != .Any
        case .rental_room:
            return editablePost.propertyType != .Any && editablePost.roomType != .Any && editablePost.tenantType != .Any && editablePost.occupant != .Any && editablePost.occupant != .Any && editablePost.leaseTerm != .Any
        case .selling:
            return editablePost.propertyType != .Any && editablePost.tenure != .Any && editablePost.floorLevel != .Any && editablePost.baths != .Any && editablePost.beds != .Any && editablePost.tenure != .Any
        }
    }
}
