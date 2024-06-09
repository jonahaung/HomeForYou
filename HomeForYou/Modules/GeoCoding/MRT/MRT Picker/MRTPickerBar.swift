//
//  MRTPickerBar.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 31/3/24.
//

import SwiftUI
import XUI

struct MRTPickerBar: View {

    @Binding var mrt: String
    @State private var selections = [MRT]()

    var body: some View {
        MRTListPickerBar(selections: $selections, allowMultiple: false)
            .task {
                if let found = MRT.allValues.first(where: { item in
                    item.name == mrt
                }) {
                    selections = [found]
                }
            }
            .onChange(of: selections) { oldValue, newValue in
                mrt = newValue.first?.name ?? ""
            }
    }
}
