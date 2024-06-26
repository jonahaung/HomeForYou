//
//  PersonInfo.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/6/23.
//

import Foundation
import FirebaseAuth

struct PersonInfo: Codable, Sendable, Equatable, Hashable, Identifiable {
    let id: String
    let name: String?
    let email: String?
    let photoURL: String?
    var phoneNumber: String?

    init(id: String, name: String?, phoneNumber: String?, email: String?, photoURL: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.photoURL = photoURL
        self.phoneNumber = phoneNumber
    }
    init(model: Person) {
        self.init(id: model.id, name: model.name, phoneNumber: model.phoneNumber, email: model.email, photoURL: model.photoURL)
    }
    init(user: User) {
        self.init(id: user.uid, name: user.displayName, phoneNumber: user.phoneNumber, email: user.email, photoURL: user.photoURL?.absoluteString)
    }
}
extension Person {
    var personInfo: PersonInfo {
        .init(model: self)
    }
}
