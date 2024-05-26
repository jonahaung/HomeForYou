//
//  FirebasePaths.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 4/4/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

enum FirebaseProvider {

    enum Collection {
        static let persons = "users"
        static let appConfigs = Firestore.firestore().collection("appConfigs")
    }

    enum StorageProvider {
        static let home_carousel_images = Storage.storage().reference().child("appConfigs/home_carousel_images")
    }

}
