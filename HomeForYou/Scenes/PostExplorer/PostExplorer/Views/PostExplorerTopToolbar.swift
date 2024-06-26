//
//  PostExplorerToolbarContent.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//

import SwiftUI
import XUI

struct PostExplorerTopToolbar: ToolbarContent {
    
    @EnvironmentObject private var viewModel: PostExplorerViewModel
    @EnvironmentObject private var searchDatasource: SearchDatasource
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            AsyncButton {
                
            } label: {
                SystemImage(.ellipsis)
            }

        }
    }
}
