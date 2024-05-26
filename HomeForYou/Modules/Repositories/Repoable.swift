//
//  Repoable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/4/23.
//

import Foundation

protocol Repoable: Codable, Identifiable, Hashable {
    var id: String { get }
    var collectionPath: String { get }
}

extension Repoable {
    static func createID() -> String {
        (1.0/Double(Date.now.timeIntervalSince1970.milliseconds)).description
    }
}
