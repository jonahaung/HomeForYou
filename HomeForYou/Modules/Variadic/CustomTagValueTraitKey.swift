//
//  CustomTagValueTraitKey.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/6/24.
//

import SwiftUI

extension View {
    public func customTag<T: Hashable>(_ tag: T) -> some View {
        _trait(CustomTagValueTraitKey<T>.self, .tagged(tag))
    }
}
struct CustomTagValueTraitKey<T: Hashable>: _ViewTraitKey {
    enum Value {
        case untagged
        case tagged(T)
    }
    static var defaultValue: CustomTagValueTraitKey<T>.Value {
        .untagged
    }
}

