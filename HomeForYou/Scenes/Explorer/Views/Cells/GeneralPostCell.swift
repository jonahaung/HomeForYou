//
//  PostGridCell.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 9/2/23.
//

import SwiftUI
import XUI

struct GeneralPostCell: View {

    @EnvironmentObject private var post: Post
    let gridStyle: GridStyle

    var body: some View {
        Group {
            switch gridStyle {
            case .List:
                PostSingleColumnSmallCell()
            case .TwoCol:
                PostDoubleColumnCell()
            case .Large:
                PostSingleColumnLargeCell()
            }
        }
        .transition(.scale)
    }
}
