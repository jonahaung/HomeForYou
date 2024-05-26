//
//  ImageLoading.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import UIKit
import Nuke

public struct ImageLoader {
    enum ImageError: Error {
        case urlNotValid
    }
    public init() {}
    
    public func loadImage(
        url: URL?,
        imageCDN: ImageCDN,
        imageSize: ImageSize,
        completion: @escaping ((Result<UIImage, Error>) -> Void)
    ) {
        guard var url = url else {
            completion(.failure(ImageError.urlNotValid))
            return
        }
        
        let urlRequest = imageCDN.urlRequest(forImage: url)
        
        var processors = [ImageProcessing]()
        if imageSize != .original {
            processors = [ImageProcessors.Resize(width: imageSize.value)]
            url = imageCDN.thumbnailURL(originalURL: url, preferredSize: imageSize)
        }
        let cachingKey = imageCDN.cachingKey(forImage: url)
        let request = ImageRequest(urlRequest: urlRequest, processors: processors, priority: .high, options: .disableDiskCache, userInfo: [.imageIdKey: cachingKey])
        ImagePipeline.shared.loadImage(with: request) { result in
            switch result {
            case let .success(imageResponse):
                completion(.success(imageResponse.image))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func loadImage(
        using urlRequest: URLRequest,
        cachingKey: String?,
        priority: ImageRequest.Priority = .veryLow,
        completion: @escaping ((Result<UIImage, Error>) -> Void)
    ) {
        var userInfo: [ImageRequest.UserInfoKey: Any]?
        if let cachingKey = cachingKey {
            userInfo = [.imageIdKey: cachingKey]
        }
        
        let request = ImageRequest(
            urlRequest: urlRequest,
            priority: .veryHigh,
            userInfo: userInfo
        )
        ImagePipeline.shared.loadImage(with: request) { result in
            switch result {
            case let .success(imageResponse):
                completion(.success(imageResponse.image))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func loadImages(
        from urls: [URL],
        placeholders: [UIImage],
        thumbnailSize: ImageSize,
        imageCDN: ImageCDN,
        completion: @escaping (([UIImage]) -> Void)
    ) {
        let group = DispatchGroup()
        var images: [UIImage] = []
        for url in urls {
            var placeholderIndex = 0
            let thumbnailUrl = imageCDN.thumbnailURL(originalURL: url, preferredSize: thumbnailSize)
            var imageRequest = imageCDN.urlRequest(forImage: thumbnailUrl)
            imageRequest.timeoutInterval = 8
            let cachingKey = imageCDN.cachingKey(forImage: url)
            
            group.enter()
            
            loadImage(using: imageRequest, cachingKey: cachingKey, priority: .low) { result in
                switch result {
                case let .success(image):
                    images.append(image)
                case .failure:
                    if !placeholders.isEmpty {
                        images.append(placeholders[placeholderIndex])
                        placeholderIndex += 1
                        if placeholderIndex == placeholders.count {
                            placeholderIndex = 0
                        }
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}
