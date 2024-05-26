//
//  Post.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/2/23.
//

import Foundation
import XUI

final class Post: Codable, Hashable, Repoable, ObservableObject {

    var collectionPath: String { category.rawValue }

    var id: String
    let category: Category
    let autherID: String
    let author: PersonInfo

    var attachments = [XAttachment]() { willSet { updateUI() }}
    var roomURL: String? { willSet { updateUI() }}
    var title = String() { willSet { updateUI() } }
    var description = String() { willSet { updateUI() } }
    var phoneNumber = String() { willSet { updateUI() } }
    var price: Int = 0 { willSet { updateUI() } }
    var occupant: Occupant? { willSet { updateUI() } }

    var mrt: String = String() { willSet { updateUI() } }
    var mrtDistance: Int = 0 { willSet { updateUI() } }
    var area: Area = .Any { willSet { updateUI() } }
    var geoHash: String = String() { willSet { updateUI() } }
    var address: String = String() { willSet { updateUI() } }
    var postalCode: String = String() { willSet { updateUI() } }
    var latitude: Double = 0
    var longitude: Double = 0

    var propertyType = PropertyType.Any { willSet { updateUI() } }
    var roomType: RoomType? { willSet { updateUI() } }
    var furnishing: Furnishing? { willSet { updateUI() } }
    var beds = Bedroom.Any { willSet { updateUI() } }
    var baths = Bathroom.Any { willSet { updateUI() } }
    var floorLevel = FloorLevel.Any { willSet { updateUI() } }
    var tenantType: TenantType? { willSet { updateUI() } }
    var leaseTerm: LeaseTerm? { willSet { updateUI() } }
    var tenure: Tenure? { willSet { updateUI() } }
    var availableDate: Date = .now { willSet { updateUI() } }

    var features = [Feature]() { willSet { updateUI() } }
    var restrictions = [Restriction]() { willSet { updateUI() } }

    var status = PostStatus.Available { willSet { updateUI() } }
    var createdAt: Date = .now
    var keywords = [String]() { willSet { updateUI() } }
    var views = [String]() { willSet { updateUI() } }
    var favourites = [String]() { willSet { updateUI() } }

    var additional: [String: String]? { willSet { updateUI() } }

    init(category: Category, author: Person) {
        self.id = Post.createID()
        self.category = category
        self.autherID = author.id
        self.author = .init(model: author)
    }

    convenience init(category: Category, author: Person, location: LocationInfo) {
        self.init(category: category, author: author)
        mrt = location.nearestMRT.mrt
        mrtDistance = location.nearestMRT.distance
        area = location.area
        geoHash = location.geoInfo.geoHash
        address = location.address.text
        postalCode = location.address.postal
        latitude = location.geoInfo.latitude
        longitude = location.geoInfo.longitude
    }
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    var isEmpty: Bool {
        attachments.isEmpty && title.isEmpty && description.isEmpty && phoneNumber.isEmpty && price == 0
    }
}

extension Post {
    var _roomURL: URL? {
        get {
            if let roomURL {
                return URL(filePath: roomURL)
            }
            return nil
        }
        set {
            roomURL = newValue?.absoluteString
        }
    }
    var _occupant: Occupant {
        get { occupant ?? .Any }
        set { occupant = newValue == .Any ? nil : newValue }
    }
    var _tenure: Tenure {
        get { tenure ?? .Any }
        set { tenure = newValue == .Any ? nil : newValue }
    }
    var _leaseTerm: LeaseTerm {
        get { leaseTerm ?? .Any }
        set { leaseTerm = newValue == .Any ? nil : newValue }
    }
    var _tenantType: TenantType {
        get { tenantType ?? .Any }
        set { tenantType = newValue == .Any ? nil : newValue }
    }
    var _furnishing: Furnishing {
        get { furnishing ?? .Any }
        set { furnishing = newValue == .Any ? nil : newValue }
    }

    var _roomType: RoomType {
        get { roomType ?? .Any }
        set { roomType = newValue == .Any ? nil : newValue }
    }

    var _keyWords: [KeyWord] {
        get { keywords.compactMap { KeyWord(keyValueString: $0) } }
        set { keywords = newValue.map { $0.keyValueString }.sorted() }
    }
    var _location: LocationInfo {
        get {
            .init(
                area: area,
                nearestMRT: .init(mrt: mrt, distance: mrtDistance),
                address: .init(text: address, postal: postalCode),
                geoInfo: .init(latitude: latitude, longitude: longitude,
                               geoHash: geoHash)
            )
        }
        set {
            mrt = newValue.nearestMRT.mrt
            mrtDistance = newValue.nearestMRT.distance
            area = newValue.area
            geoHash = newValue.geoInfo.geoHash
            address = newValue.address.text
            postalCode = newValue.address.postal
            latitude = newValue.geoInfo.latitude
            longitude = newValue.geoInfo.longitude
        }
    }

    func updateUI() {
        if Thread.isMainThread {
            self.objectWillChange.send()
        } else {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}
