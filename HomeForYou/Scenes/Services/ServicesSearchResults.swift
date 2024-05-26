//
//  ServicesSearchResults.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/2/24.
//

import SwiftUI

struct ServicesSearchResults: View {
    
    @Binding var searchText: String
    @State private var group:  ServicesGroup
    
    init(_ searchText: Binding<String>, serviceGroup: ServicesGroup) {
        _searchText = searchText
        group = serviceGroup
    }
    
    var body: some View {
        if $searchText.wrappedValue.isWhitespace {
            ForEach(group.services) {
                ServiceCell(service: $0)
            }
        } else {
            ForEach(group.services.filter {
                $0.rawValue.lowercased().contains($searchText.wrappedValue.lowercased())
            }) {
                ServiceCell(service: $0)
            }
        }
    }
}
