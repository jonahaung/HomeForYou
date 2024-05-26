//
//  ViewDisplayable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/1/24.
//

import SwiftUI

protocol ViewDisplayable: Identifiable, Hashable, Equatable  {
    associatedtype DisplayableView: View
    var id: String { get }
    var viewToDisplay: DisplayableView { get }
}

extension ViewDisplayable {
    var id: String { DisplayableView.typeName }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
