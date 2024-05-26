//
//  _Picker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI
import XUI

// public struct _Picker<Item>: View where Item: Hashable, Item: XPickable {
//
//    private let items: [Item]
//    private var selection: Binding<Item>
//
//    init(_ _items: [Item], _ _selection: Binding<Item>) {
//        items = _items
//        selection = _selection
//    }
//
//    public var body: some View {
//        Picker("", selection: selection) {
//            ForEach(items, id: \.self) {
//                Text($0.title)
//                    .tag($0.title)
//            }
//        }
//    }
// }
