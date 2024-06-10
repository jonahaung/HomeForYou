//
//  MoreServicesView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/6/23.
//

import SwiftUI
import XUI

struct ServicesView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        Form {
            ForEach(ServicesGroup.allCases) { group in
                Section {
                    ServicesSearchResults($searchText, serviceGroup: group)
                } header: {
                    Text(group.title)
                }
            }
        }
        .searchable(text: $searchText)
        .navigationBarItems(trailing: trailingItem)
    }
    
    private var trailingItem: some View {
        SystemImage(.bellBadgeFill)
            .symbolRenderingMode(.multicolor)
            ._presentSheet {
                LocationPickerMap { item in
                    Log(item)
                }
            }
    }
}
