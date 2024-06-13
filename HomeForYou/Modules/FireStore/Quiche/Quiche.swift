//
//  Quiche.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import Foundation
import FirebaseFirestore

public class Quiche {
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
    
    public func `where`<V>(_ keyPath: String, isEqualTo value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isEqualTo: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: String, isEqualTo value: V) -> Quiche where V: RawRepresentable {
        updateQuery { $0.whereField(keyPath, isEqualTo: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: String, isLessThan value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isLessThan: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: String, isLessThanOrEqualTo value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isLessThanOrEqualTo: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: String, isGreaterThan value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isGreaterThan: value) }
        return self
    }
    
    public func `where`<V>(_ keyPath: String, isGreaterThanOrEqualTo value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, isGreaterThanOrEqualTo: value) }
        return self
    }
    public func `where`<V>(_ keyPath: String, arrayContains value: V) -> Quiche {
        updateQuery { $0.whereField(keyPath, arrayContains: value) }
        return self
    }
    public func `where`<V>(_ keyPath: String, arrayContainsAny value: [V]) -> Quiche {
        updateQuery { $0.whereField(keyPath, arrayContainsAny: value) }
        return self
    }
    public func order(by keyPath: String) -> Quiche {
        updateQuery { $0.order(by: keyPath) }
        return self
    }
    
    public func order(by keyPath: String, descending: Bool) -> Quiche {
        updateQuery { $0.order(by: keyPath, descending: descending) }
        return self
    }
    
    public func whereReference(_ field: String, isEqualTo reference: DocumentReference) -> Quiche {
        updateQuery { $0.whereField(field, isEqualTo: reference) }
        return self
    }
}
