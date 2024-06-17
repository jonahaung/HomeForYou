//
//  GridMultiPicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/6/23.
//

import SwiftUI
import XUI

struct GridMultiPicker<Item>: View where Item: XPickable, Item: Equatable {
    
    private let sourceItems: [Item]
    private var selected: Binding<[Item]>
    private var columns: [GridItem]
    
    init(source: [Item], selection: Binding<[Item]>, colNum: Int = 2) {
        sourceItems = source
        selected = selection
        columns = Array(repeating: GridItem(.flexible()), count: colNum)
    }
    
    var body: some View {
        VStack {
            WrappedStack(.vertical, spacing: 3) {
                ForEach(sourceItems, id: \.title) { each in
                    SelectableTag(title: each.title, isSelected: .init(get: {
                        selected.wrappedValue.contains(each)
                    }, set: { newValue in
                        if newValue {
                            selected.wrappedValue.append(each)
                        } else {
                            if let i = selected.wrappedValue.firstIndex(of: each) {
                                selected.wrappedValue.remove(at: i)
                            }
                        }
                    }))
                }
            }
        }.padding(2)
    }
}
