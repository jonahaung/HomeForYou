//
//  PostExplorerCellDisplayData.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 3/6/24.
//

import SwiftUI

struct PostCellDisplayData: Identifiable {
    
    typealias Tag = (PostKeys, String)
    
    var id: String { post.id }
    
    let title: AttributedString
    let price: String
    let createdAt: String
    var primaryTags = [Tag]()
    var secondaryTags = [Tag]()
    
    let post: Post
    init(_ post: Post) {
        self.post = post
        @Injected(\.utils) var utils
        price = utils.kmbFormatter.string(for: post.price) ?? ""
        title = {
            let string = AttributedString(
                post.title, attributes: .init([.font: UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium), .paragraphStyle: NSMutableParagraphStyle.wordWrappingLineBreak]))
            
            return string
        }()
        createdAt = utils.timeAgoFormatter.string(from: post.createdAt)
        
        primaryTags = [
            (.propertyType, post.propertyType.title),
            (.roomType, post._roomType.title),
            (.beds, post.beds.rawValue),
            (.baths, post.baths.rawValue),
        ]
        
        secondaryTags = [
            (.area, post.area.title),
            (.mrt, post.mrt)
        ]
    }
}
