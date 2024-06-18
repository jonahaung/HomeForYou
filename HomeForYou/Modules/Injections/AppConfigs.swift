//
//  AppConfig.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 4/4/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import XUI

@Observable
final class AppConfigs {

    private let reference = FirebaseProvider.Collection.appConfigs
    var home_carousel_images = [XAttachment]()

    init() {
        let urls = ["https://pic2.99.co/v3/UDx5qgu4uASeh6L6RZRCLB?text=&sampling=lanczos&version=1&mode=fill&quality=80&convert_if_png=true&signature=6df63dabe9aad01f5e4d5bd480cd8b5be6264cf9&width=1600", "https://pic2.99.co/v3/HPGAxUkjwobpEprufDZpSh?text=&sampling=lanczos&version=1&mode=fill&quality=80&convert_if_png=true&signature=2db66a578c88c52b718c3d2d35aae5ec22b733cd&width=1600", "https://pic2.99.co/v3/z4hxkCKi6bZb6zfXbh9D4d?text=&sampling=lanczos&version=1&mode=fill&quality=80&convert_if_png=true&signature=f57eb4f034220c61745aeff37f18c961c4a89dd7&width=1600", "https://pic2.99.co/v3/9ZgjWYwMxgGRvYrCyANMgg?text=&sampling=lanczos&version=1&mode=fill&quality=80&convert_if_png=true&signature=bcafec3f6296116954b92b447e82def9528d1b89&width=1600", "https://pic2.99.co/v3/D5krtmeUMBcMezWi2SfW5D?text=&sampling=lanczos&version=1&mode=fill&quality=80&convert_if_png=true&signature=975720c443cda99e65b411f1f84b4567ecbbd29d&width=1600", "https://pic2.99.co/v3/XkWNqv86FwuoDbcWjaeq2k?text=&sampling=lanczos&version=1&mode=fill&quality=80&convert_if_png=true&signature=908130fbfcb7035d8df6ec60c2759693ef490f4d&width=1600", "https://pic2.99.co/v3/BHAY2uLobLTxJFpFGJWUHk?text=&sampling=lanczos&version=1&mode=fill&quality=80&convert_if_png=true&signature=e23fce34182e575069056dffc4637b5ba21e732e&width=1600"]
        home_carousel_images = urls.map { XAttachment(url: $0, type: .photo)}
    }

    func initialize() {

    }
    func getCarousellImages() {
//        FirebaseProvider
//            .StorageProvider
//            .home_carousel_images
//            .listAll { [weak self] result, error in
//                guard  let self else { return }
//                DispatchQueue.main.async {
//                    if let error {
//                        print(error)
//                    }
//                    let group = DispatchGroup()
//                    var urls = [URL]()
//                    result?.items.forEach({ each in
//                        group.enter()
//                        each.downloadURL { url, error in
//                            if let url {
//                                urls.append(url)
//                            }
//                            group.leave()
//                        }
//                    })
//                    group.notify(queue: .main) { [weak self] in
//                        guard let self else { return }
//                        print(urls)
//                        self.home_carousel_images = urls.map { .init(url: $0.absoluteString, type: .photo)}
//                    }
//                }
//            }
    }
}
