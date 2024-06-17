//
//  Mock+Post.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/5/24.
//

import Foundation
import XUI

extension Post {
    static func mock(for i: Int) -> [Post] {
        var posts = [Post]()
        (1...i).forEach { i in
            let post = Post(category: .rental_room, author: .init())
            post.id = Post.createID()
            post.title = Lorem.title
            post.price = 1000
            post.attachments = [XAttachment.init(url: DemoImages.demoPhotosURLs.random()!.absoluteString, type: .photo)]
            posts.append(post)
        }
        return posts
    }
}
