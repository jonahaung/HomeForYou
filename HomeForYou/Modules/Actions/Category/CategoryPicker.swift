//
//  PostTypePicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import SwiftUI
import XUI

struct CategoryPicker: View {
    
    @AppStorage("category") private var category: Category = .rental_room
    @State private var currentCategory: Category?
    @Environment(\.onUpdateCategory) private var updateCategory
    
    var body: some View {
        Picker(selection: $category) {
            ForEach(Category.allCases, id: \.rawValue) {
                Text($0.title)
                    .tag($0)
            }
        } label: {
            Text("Post Type")
        }
        .labelsHidden()
        .task(id: category, priority: .background) {
            guard currentCategory != category else { return }
            currentCategory = category
            Log(category)
            await updateCategory?(category)
        }
        .equatable(by: category)
    }
}
