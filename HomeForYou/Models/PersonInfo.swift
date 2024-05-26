//
//  PersonInfo.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/6/23.
//

import Foundation
import FirebaseAuth

struct PersonInfo: Codable, Sendable {
    
    let id: String
    let name: String?
    let email: String?
    let photoURL: String?

    init(model: Person) {
        self.id = model.id
        self.name = model.name
        self.email = model.email
        self.photoURL = model.photoURL
    }

    init(user: User) {
        self.id = user.uid
        self.name = user.displayName
        self.email = user.phoneNumber
        self.photoURL = user.photoURL?.absoluteString
    }
}

extension Person {
    var personInfo: PersonInfo {
        .init(model: self)
    }
}
