//
//  Query++.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import Foundation
import FirebaseFirestore

private func keyPathToField<R,V>(_ keyPath: KeyPath<R, V>) -> String {
    guard let field = keyPath._kvcKeyPathString else {
        fatalError("invalid keyPath: \(keyPath)")
    }
    return field
}

public extension Query {
    func whereField<R, V>(_ keyPath: KeyPath<R, V>, isEqualTo value: V) -> Query {
        return whereField(keyPathToField(keyPath), isEqualTo: value)
    }

    func whereField<R, V>(_ keyPath: KeyPath<R, V>, isEqualTo value: V) -> Query where V: RawRepresentable {
        return whereField(keyPathToField(keyPath), isEqualTo: value.rawValue)
    }

    func whereField<R, V>(_ keyPath: KeyPath<R, V>, isLessThan value: V) -> Query {
        return whereField(keyPathToField(keyPath), isLessThan: value)
    }

    func whereField<R, V>(_ keyPath: KeyPath<R, V>, isLessThanOrEqualTo value: V) -> Query {
        return whereField(keyPathToField(keyPath), isLessThanOrEqualTo: value)
    }

    func whereField<R, V>(_ keyPath: KeyPath<R, V>, isGreaterThan value: V) -> Query {
        return whereField(keyPathToField(keyPath), isGreaterThan: value)
    }

    func whereField<R, V>(_ keyPath: KeyPath<R, V>, isGreaterThanOrEqualTo value: V) -> Query {
        return whereField(keyPathToField(keyPath), isGreaterThanOrEqualTo: value)
    }
    func whereField<R, V>(_ keyPath: KeyPath<R, V>, arrayContains value: V) -> Query {
        return whereField(keyPathToField(keyPath), arrayContains: value)
    }
    func whereField<R, V>(_ keyPath: KeyPath<R, V>, arrayContainsAny value: [V]) -> Query {
        return whereField(keyPathToField(keyPath), arrayContainsAny: value)
    }
    func order<R, V>(by keyPath: KeyPath<R, V>) -> Query {
        return order(by: keyPathToField(keyPath))
    }

    func order<R, V>(by keyPath: KeyPath<R, V>, descending: Bool) -> Query {
        return order(by: keyPathToField(keyPath), descending: descending)
    }

    func whereReference(_ field: String, isEqualTo reference: DocumentReference) -> Query {
        return whereField(field, isEqualTo: reference)
    }
}
