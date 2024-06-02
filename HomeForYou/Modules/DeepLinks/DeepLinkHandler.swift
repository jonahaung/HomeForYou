//
//  DeepLink.swift
//  Msgr
//
//  Created by Aung Ko Min on 16/1/23.
//

import Foundation
import SwiftUI
import XUI

struct DeepLinkHandler {
    
    static let scheme = "homeforyou.com.sg"
    
    func canOpenURL(_ url: URL) -> Bool {
        url.scheme == DeepLinkHandler.scheme && url.scheme?.localizedCaseInsensitiveCompare(DeepLinkHandler.scheme) == .orderedSame
    }
    
    func createURL(for screen: SceneItem) -> URL? {
        var components = URLComponents()
        components.scheme = DeepLinkHandler.scheme
        components.host = screen.kind.rawValue
        switch screen.kind {
        case .postDetails:
            if let post = screen.data as? Post {
                components.queryItems = [.init(name: PostKeys.id.rawValue, value: post.id), .init(name: PostKeys.category.rawValue, value: post.category.rawValue)]
            }
        case .postCollection:
            if let filters = screen.data as? [PostFilter] {
                components.queryItems = filters.map{ .init(postFilter: $0) }
            }
        default:
            break
        }
        return components.url
    }
    
    func parse(for url: URL) async throws -> SceneItem {
        guard
            canOpenURL(url),
            let components = URLComponents(string: url.absoluteString),
            let screenType = SceneKind(url: url)
        else {
            throw XError.deeplink_unsupported_url
        }
        
        let queryItems = components.queryItems ?? []
        switch screenType {
        case .postDetails:
            guard
                let id = queryItems.first(where: { $0.name == PostKeys.id.rawValue })?.value,
                let categoryString = queryItems.first(where: { $0.name == PostKeys.category.rawValue })?.value,
                let category = Category(rawValue: categoryString)
            else {
                throw XError.deeplink_unsupported_url
            }
            let post = try await Repo.shared.async_fetch(path: category.rawValue, for: id, as: Post.self)
            return SceneItem(screenType, data: post)
        case .postCollection:
            let filters = queryItems.compactMap{ PostFilter(queryItem: $0) }
            return SceneItem(screenType, data: filters)
        default:
            return SceneItem(screenType)
        }
    }
}
