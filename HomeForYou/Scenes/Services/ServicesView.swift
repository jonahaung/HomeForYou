//
//  MoreServicesView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/6/23.
//

import SwiftUI

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
    }
}
