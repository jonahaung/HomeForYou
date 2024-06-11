//
//  ValuePicker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/6/24.
//

import SwiftUI
import XUI

public struct InsetGroupList<V: Hashable, Content: View>: View {
    
    private let selection: Binding<V>?
    private let content: Content
    
    @State private var innerPadding: CGFloat
    @State private var outerPadding: CGFloat
    
    public init(selection: Binding<V>? = .constant(0), innerPadding: CGFloat = 16.scaled, outerPadding: CGFloat = 16.scaled, @ViewBuilder content: () -> Content) {
        self.selection = selection
        self.innerPadding = innerPadding
        self.outerPadding = outerPadding
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            _VariadicView.Tree(
                VInsetGroupListSection(selectedValue: selection)
            ) {
                content
            }
        }
        .padding(innerPadding)
        .background(Color.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: innerPadding < 10 ? 8 : 12))
        .padding(outerPadding)
        ._flexible(.horizontal)
    }
}
public extension InsetGroupList {
    func outerPadding(_ value: CGFloat) -> InsetGroupList {
        let result = self
        result.outerPadding = value
        return result
    }
    func innerPadding(_ value: CGFloat) -> InsetGroupList {
        let result = self
        result.innerPadding = value
        return result
    }
}

private struct VInsetGroupListSection<V: Hashable>: _VariadicView.MultiViewRoot {
    let selectedValue: Binding<V>?
    func body(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            VInsetGroupListCell(value: child[CustomTagValueTraitKey<V>.self], selectedValue) {
                child
            }
        }
    }
}
private struct VInsetGroupListCell<Content: View, V: Hashable>: View {
    private let selectedValue: Binding<V>?
    private let value: V?
    private let content: Content
    
    init(value: CustomTagValueTraitKey<V>.Value, _ selectedValue: Binding<V>?, @ViewBuilder _ content: () -> Content) {
        self.selectedValue = selectedValue
        self.value = if case .tagged(let tag) = value {
            tag
        } else {
            nil
        }
        self.content = content()
    }
    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var isSelected: Bool {
        selectedValue?.wrappedValue == value
    }
}
