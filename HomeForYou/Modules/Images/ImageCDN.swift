//
//  ImageCDN.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import UIKit

public enum ImageSize {
    case small
    case medium
    case original
    
    var value: CGFloat {
        switch self {
        case .small:
            return 40
        case .medium:
            return 300
        case .original:
            return .infinity
        }
    }
}

public protocol ImageCDN {
    func cachingKey(forImage url: URL) -> String
    func urlRequest(forImage url: URL) -> URLRequest
    func thumbnailURL(originalURL: URL, preferredSize: ImageSize) -> URL
}

extension ImageCDN {
    public func urlRequest(forImage url: URL) -> URLRequest {
        URLRequest(url: url)
    }
}

open class XImageCDN: ImageCDN {
    public init() {}
    open func cachingKey(forImage url: URL) -> String {
        let key = url.absoluteString
        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { return key }
        let persistedParameters = ["w", "h"]

        let newParameters = components.queryItems?.filter { persistedParameters.contains($0.name) } ?? []
        components.queryItems = newParameters.isEmpty ? nil : newParameters
        return components.string ?? key
    }
    open func urlRequest(forImage url: URL) -> URLRequest {
        URLRequest(url: url)
    }
    open func thumbnailURL(originalURL: URL, preferredSize: ImageSize) -> URL {
        guard
            var components = URLComponents(url: originalURL, resolvingAgainstBaseURL: true)
        else { return originalURL }
        components.queryItems = components.queryItems ?? []
        var queryItems = [URLQueryItem]()
        if preferredSize != .original {
            queryItems.append(contentsOf: [
                URLQueryItem(name: "w", value: String(format: "%.0f", preferredSize.value)),
                URLQueryItem(name: "h", value: String(format: "%.0f", preferredSize.value)),
            ])
        }
        components.queryItems?.append(contentsOf: queryItems)
        return components.url ?? originalURL
    }
}
