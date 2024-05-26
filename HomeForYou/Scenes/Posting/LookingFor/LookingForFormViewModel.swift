//
//  LookingForFormViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 8/6/23.
//

import Foundation

class LookingForFormViewModel: ObservableObject {

    @Published var looking: Looking
    @Published var mrts = [MRT]()
    init(_ category: Category) {
        looking = .init(category: category)
    }

    var isValid: Bool {
        !mrts.isEmpty &&
        looking.propertyType != .Any &&
        looking.price_max > 0 &&
        !looking.title.isEmpty &&
        !looking.description.isEmpty &&
        !looking.phone.isEmpty
    }
    var isEmpty: Bool {
        looking.mrts.isEmpty && looking.title.isEmpty && looking.phone.isEmpty && looking.propertyType == .Any && looking.description.isEmpty && looking.price_max == 0
    }
}
