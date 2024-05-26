//
//  PriceRangePicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 31/5/23.
//

import SwiftUI

struct PriceRangePicker: View {

    @Binding var range: PriceRange

    var body: some View {
        HStack {
            TextField("Min Price", text: .constant("\(range)"))
//            TextField("Max Price", text: .init(get: {
//                return "\(range.max)"
//            }, set: { newValue in
//                $range.max = Int(newValue) ?? 0
//            }))
        }
        .keyboardType(.numberPad)
    }

}
