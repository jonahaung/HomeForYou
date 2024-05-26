//
//  AddressPickerView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/2/23.
//

import SwiftUI
import XUI

struct AddressPickerView: View {

    @StateObject private var viewModel = AddressAutoComplete()
    @Binding var addressText: String
    @Environment(\.dismiss) private var dismiss
    @Injected(\.router) private var router
    @Injected(\.locationManager) private var locationManager
    @State private var isPresentedSearch = true
    var body: some View {
        List(self.viewModel.results) { address in
            Button {
                addressText = address.fullAddress
                dismiss()
            } label: {
                AddressRow(address: address)
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

struct AddressRow: View {
    let address: Address
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(.init(address.fullAddress))
        }
    }
}
