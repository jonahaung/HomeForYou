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
        let urls = (0...7).map { _ in DemoImages.demoPhotosURLs.random()!.absoluteString }.uniqued()
//        let urls = ["https://firebasestorage.googleapis.com:443/v0/b/home-for-you-db25b.appspot.com/o/appConfigs%2Fhome_carousel_images%2FWhatsApp%20Image%202023-04-02%20at%203.01.52%20PM%20(2).jpeg?alt=media&token=b4fb6447-7fed-4160-a6bd-a6ecbb07decb", "https://firebasestorage.googleapis.com:443/v0/b/home-for-you-db25b.appspot.com/o/appConfigs%2Fhome_carousel_images%2FWhatsApp%20Image%202023-04-02%20at%203.01.50%20PM%20(1).jpeg?alt=media&token=35b5c12d-a9f4-467b-a836-2ef2f1e24091", "https://firebasestorage.googleapis.com:443/v0/b/home-for-you-db25b.appspot.com/o/appConfigs%2Fhome_carousel_images%2FWhatsApp%20Image%202023-04-02%20at%203.01.52%20PM.jpeg?alt=media&token=52ed2ce8-30a3-4ed0-9989-ce76267473ac", "https://firebasestorage.googleapis.com:443/v0/b/home-for-you-db25b.appspot.com/o/appConfigs%2Fhome_carousel_images%2FWhatsApp%20Image%202023-04-02%20at%203.01.51%20PM.jpeg?alt=media&token=395fea00-9548-4b50-aa25-5aecfcb1934f", "https://firebasestorage.googleapis.com:443/v0/b/home-for-you-db25b.appspot.com/o/appConfigs%2Fhome_carousel_images%2FWhatsApp%20Image%202023-04-02%20at%203.01.52%20PM%20(1).jpeg?alt=media&token=2ae3f1de-92a6-4830-bddf-05435ac4b8ea", "https://firebasestorage.googleapis.com:443/v0/b/home-for-you-db25b.appspot.com/o/appConfigs%2Fhome_carousel_images%2FWhatsApp%20Image%202023-04-02%20at%203.01.50%20PM.jpeg?alt=media&token=0f572180-5e0f-4d19-bcf5-ec386edf601c", "https://firebasestorage.googleapis.com:443/v0/b/home-for-you-db25b.appspot.com/o/appConfigs%2Fhome_carousel_images%2FWhatsApp%20Image%202023-04-02%20at%203.02.33%20PM.jpeg?alt=media&token=cb938502-cbf2-487f-83b0-aaa130e78eb8"]

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
