//
//  PostExplorerCellDisplayData.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/6/24.
//

import SwiftUI

struct PostCellDisplayData: Identifiable {
    
    typealias Tag = (PostKey, String)
    
    var id: String { post.id }
    let title: String
    let price: String
    let createdAt: String
    var primaryTags = [Tag]()
    var secondaryTags = [Tag]()
    
    let post: Post
    
    init(_ post: Post) {
        self.post = post
        @Injected(\.utils) var utils
        @Injected(\.ui) var ui
        price = "$" + (utils.kmbFormatter.string(for: post.price) ?? "")
        title = {
            post.title
        }()
        createdAt = utils.timeAgoFormatter.string(from: post.createdAt)
        
        primaryTags = [
            (.propertyType, post.propertyType.rawValue.uppercased()),
            (.roomType, post._roomType.rawValue.uppercased()),
            (.beds, post.beds.rawValue.uppercased()),
            (.baths, post.baths.rawValue.uppercased()),
        ]
        
        secondaryTags = [
            (.area, post.area.rawValue.uppercased()),
            (.mrt, post.mrt.uppercased())
        ]
    }
}
extension PostCellDisplayData: Hashable {
    static func == (lhs: PostCellDisplayData, rhs: PostCellDisplayData) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
