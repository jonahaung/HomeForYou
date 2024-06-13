//
//  AddressPickerView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/2/23.
//

import SwiftUI
import XUI

struct AddressPickerView: View {
    
    @Binding var addressText: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var isPresentedSearch = true
    @StateObject private var viewModel = AddressAutoComplete()
    
    var body: some View {
        List(viewModel.results) { address in
            Button {
                addressText = address.fullAddress
                dismiss()
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(.init(address.fullAddress))
                }
            }
            .buttonStyle(.plain)
        }
        .searchable(text: $viewModel.searchableText, isPresented: $isPresentedSearch, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Address")
        .disableAutocorrection(true)
        .textInputAutocapitalization(.words)
        .navigationBarItems(leading: _DismissButton())
        .embeddedInNavigationView()
    }
}
