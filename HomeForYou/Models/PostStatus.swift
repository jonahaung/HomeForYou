//
//  PostStatus.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/6/23.
//

import Foundation

enum PostStatus: String, StringViewRepresentable {
    static var empty: Self { .Any }
    case `Any`, Available, Hidden, Sold
}
