//
//  Quiche.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import Foundation
import FirebaseFirestore

public class Quiche<Model> {
    private var query: Query
    
    public init (_ query: Query) {
        self.query = query
    }
    
    public func bake() -> Query {
        return query
    }
    
    private func updateQuery(_ block: (Query) -> (Query)) {
        self.query = block(query)
    }
    
    public func `where`<V>(_ keyPath: KeyPath<Model, V>, isEqualTo value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isEqualTo: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: KeyPath<Model, V>, isEqualTo value: V) -> Quiche where V: RawRepresentable {
        updateQuery { $0.whereField(keyPath, isEqualTo: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: KeyPath<Model, V>, isLessThan value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isLessThan: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: KeyPath<Model, V>, isLessThanOrEqualTo value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isLessThanOrEqualTo: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: KeyPath<Model, V>, isGreaterThan value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isGreaterThan: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: KeyPath<Model, V>, isGreaterThanOrEqualTo value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isGreaterThanOrEqualTo: value) }
        return self
    }
    public func order<V>(by keyPath: KeyPath<Model, V>) -> Quiche {
        updateQuery { $0.order(by: keyPath) }
        return self
    }
    
    public func order<V>(by keyPath: KeyPath<Model, V>, descending: Bool) -> Quiche {
        updateQuery { $0.order(by: keyPath, descending: descending) }
        return self
    }
    
    public func whereReference(_ field: String, isEqualTo reference: DocumentReference) -> Quiche {
        updateQuery { $0.whereField(field, isEqualTo: reference) }
        return self
    }
    public func whereReference(_ field: String, isEqualTo value: String) -> Quiche {
        updateQuery { $0.whereField(field, isEqualTo: value ) }
        return self
    }
    public func whereReference(_ field: String, arrayContains value: Any) -> Quiche {
        updateQuery { $0.whereField(field, arrayContains: value) }
        return self
    }
    public func whereReference(_ field: String, arrayContainsAny value: [Any]) -> Quiche {
        updateQuery { $0.whereField(field, arrayContainsAny: value) }
        return self
    }
    public func whereReference(_ field: String, isGreaterThanOrEqualTo value: Any) -> Quiche {
        updateQuery { $0.whereField(field, isGreaterThanOrEqualTo: value) }
        return self
    }
    public func whereReference(_ field: String, isLessThanOrEqualTo value: Any) -> Quiche {
        updateQuery { $0.whereField(field, isLessThanOrEqualTo: value) }
        return self
    }
}
