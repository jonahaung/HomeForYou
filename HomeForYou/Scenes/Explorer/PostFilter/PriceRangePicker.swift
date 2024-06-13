//
//  PriceRangePicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 31/5/23.
//

import SwiftUI
import XUI

struct PriceRangePicker: View {

    @Binding var range: PriceRange

    var body: some View {
        HStack {
            _NumberTextField(value: .init(get: {
                return Int(range.range.lowerBound)
            }, set: { new in
                range = .init(range: new.double...range.range.upperBound)
            }), title: "Max", delima: "$")
            Divider()
            TextField("Min Price", text: .constant("\(range)"))
            _NumberTextField(value: .init(get: {
                return Int(range.range.upperBound)
            }, set: { new in
                range = .init(range: range.range.lowerBound...new.double)
            }), title: "Max", delima: "$")
        }
        .keyboardType(.numberPad)
    }

}
