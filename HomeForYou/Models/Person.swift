//
//  Person.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/1/23.
//

import Foundation
import FirebaseAuth
import XUI

struct Person: Repoable, Equatable {

    var collectionPath: String { Self.collectionID }
    static var collectionID: String { FirebaseProvider.Collection.persons }

    var id: String
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var photoURL: String = ""
    var isVerified: Bool?
    var providerIDs: [String]?
    var metaData: MetaData?

    init(user: User) {
        id = user.uid
        name = user.displayName ?? ""
        email = user.email ?? ""
        phoneNumber = user.phoneNumber ?? ""
        photoURL = user.photoURL?.absoluteString ?? ""
        isVerified = user.isEmailVerified
        providerIDs = user.providerData.map { $0.providerID }
        metaData = .init(lastSignInDate: user.metadata.lastSignInDate, creationDate: user.metadata.creationDate)
    }

    init() {
        id = "id"
    }

    struct MetaData: Codable, Hashable {
        let lastSignInDate: Date?
        let creationDate: Date?
    }
}

extension Person {
    enum CodingKeys: String, CodingKey, Codable, CaseIterable, Identifiable {
        var id: String { rawValue }
        case id, name, email, phoneNumber, photoURL, isVerified, providerIDs, metaData
    }
}

extension Person {
    var isValid: Bool { !id.isEmpty && id != "id" }
}
