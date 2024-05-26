//
//  Post++.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/8/23.
//

import SwiftUI

extension Post {
    func getPostCaption() -> LocalizedStringKey {
        switch self.category {
        case .rental_room:
            return "*\(self.propertyType.title)* **\(self.roomType?.title.lowercased() ?? "")-room** for rent near ***\(self.mrt.capitalized) MRT***"
        case .rental_flat:
            return "**\(self.propertyType.title.uppercased())** the whole unit for rent near ***\(self.mrt.capitalized) MRT***"
        case .selling:
            return "**\(self.propertyType.title.uppercased())** for sale near ***\(self.mrt.capitalized) MRT***"
        }
    }
}
