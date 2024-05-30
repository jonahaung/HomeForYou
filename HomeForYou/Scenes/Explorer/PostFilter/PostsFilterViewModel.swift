//
//  PostsFilterViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI

final class PostsFilterViewModel: ObservableObject {

    @Published var filters: PostFiltersGroup = .init([], category: .current)
}
