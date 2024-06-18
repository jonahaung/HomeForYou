//
//  PostTypePicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 14/5/23.
//

import SwiftUI
import XUI
import Combine
struct CategoryPicker: View {
    
    @AppStorage(K.Defaults.currentCategory.rawValue) private var category: Category = .current
    @State private var currentCategory: Category?
    @Environment(\.onUpdateCategory) private var updateCategory
    
    var body: some View {
        Picker(selection: $category) {
            ForEach(Category.allCases) {
                Text($0.title)
                    .tag($0)
            }
        } label: {
            Text("")
        }
        .labelsHidden()
        .pickerStyle(.segmented)
        .task(id: category.rawValue, debounceTime: .seconds(0.3)) {
            guard currentCategory != category else { return }
            currentCategory = category
            await updateCategory?(.current)
        }
    }
}
