//
//  OfferServicesForm.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/2/23.
//

import SwiftUI
import XUI

struct OfferServicesForm: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Mover Services")
                Text("Delivery Services")
                Text("House Cleaner")
                Text("Garage Sale")
                Text("Property Agents")
                Text("Message Board")
                Text("Ask a Questions")
                Text("Legal Services")
                Text("Useful Links")
            }
            .foregroundColor(.accentColor)
            .navigationBarTitle(.init("Services"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    _DismissButton(isProtected: false)
                }
            }
        }
    }
}
