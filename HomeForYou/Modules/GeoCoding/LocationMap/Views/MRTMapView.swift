//
//  MRTMapView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/24.
//

import SwiftUI
import XUI

struct MRTMapView: View {
    private let mrts = MRT.allValues
    private var items: [LocationMapItem] {
        if searchText.isWhitespace {
            return mrts.map { $0.locationMapItem }
        } else {
            return mrts.filter{ $0.name.contains(searchText, caseSensitive: false)}.map{ $0.locationMapItem }
        }
    }
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            LocationMap(items)
                .ignoresSafeArea()
                .searchable(text: $searchText)
                .navigationBarItems(leading: _DismissButton())
        }
    }
}
