//
//  EncodableExtensions.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/1/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import XUI
enum EncodableExtensionError: Error {
    case encodingError
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

extension Encodable {
    func toFirestoreData(excluding excludedKeys: [String] = [] ) throws -> [String: Any] {
        let encoder = FirestoreEncoder()
        guard var docData = try? encoder.encode(self) else { fatalError() }

        for key in excludedKeys {
            docData.removeValue(forKey: key)
        }

        return docData
    }

    func toDictionary() -> NSDictionary? {
        do {
            let encoded = try toFirestoreData()
            return encoded as NSDictionary
        } catch {
            Log(error)
            return nil
        }
    }
}
