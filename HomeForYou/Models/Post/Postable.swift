//
//  Postable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/5/24.
//

import Foundation
import XUI

protocol Postable: Repoable {
    
    var collectionPath: String { get }
    var id: String { get set }
    var category: Category { get set}
    var author: PersonInfo { get set }
    
    var attachments: [XAttachment] { get set }
    var roomURL: String? { get set }
    var title: String { get set }
    var description: String { get set }
    var phoneNumber: String { get set }
    var price: Int { get set }
    var occupant: Occupant? { get set }
    
    var mrt: String { get set }
    var mrtDistance: Int { get set }
    var area: Area { get set }
    var geoHash: String { get set }
    var address: String { get set }
    var postalCode: String { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    
    var propertyType: PropertyType { get set }
    var roomType: RoomType? { get set }
    var furnishing: Furnishing? { get set }
    var beds: Bedroom { get set }
    var baths: Bathroom { get set }
    var floorLevel: FloorLevel { get set }
    var tenantType: TenantType? { get set }
    var leaseTerm: LeaseTerm? { get set }
    var tenure: Tenure? { get set }
    var availableDate: Date { get set }
    
    var features: [Feature] { get set }
    var restrictions: [Restriction] { get set }
    
    var status: PostStatus { get set }
    var createdAt: Date { get set }
    var keywords: [String] { get set }
    var views: [String] { get set }
    var favourites: [String] { get set }
    
    var additional: [String: String]? { get set }
    
    init()
    init(category: Category, authorInfo: PersonInfo)
    
    func updateUI()
}

extension Postable {
    init() {
        self.init(category: .current, author: .init())
    }
    init(category: Category, author: Person) {
        self.init(category: category, authorInfo: PersonInfo(id: author.id, name: author.name, phoneNumber: author.phoneNumber, email: author.email, photoURL: author.photoURL))
    }
    init(category: Category, author: Person, location: LocationInfo) {
        self.init(category: category, authorInfo: PersonInfo(id: author.id, name: author.name, phoneNumber: author.phoneNumber, email: author.email, photoURL: author.photoURL), location: location)
    }
    init(category: Category, authorInfo: PersonInfo, location: LocationInfo) {
        self.init(category: category, authorInfo: authorInfo)
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
extension Postable {
    mutating func copy<T: Postable>(from item: T) {
        id = item.id
        category = item.category
        author = item.author
        _location = item._location
        attachments = item.attachments
        roomURL = item.roomURL
        title = item.title
        description = item.description
        phoneNumber = item.phoneNumber
        price = item.price
        occupant = item.occupant
        propertyType = item.propertyType
        roomType = item.roomType
        furnishing = item.furnishing
        beds = item.beds
        baths = item.baths
        floorLevel = item.floorLevel
        tenantType = item.tenantType
        leaseTerm = item.leaseTerm
        tenure = item.tenure
        availableDate = item.availableDate
        features = item.features
        restrictions = item.restrictions
        status = item.status
        createdAt = item.createdAt
        keywords = item.keywords
        views = item.views
        favourites = item.favourites
        additional = item.additional
    }
    func clone<T: Postable>() -> T {
        var item = T()
        item.copy(from: self)
        return item
    }
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    var isEmpty: Bool {
        attachments.isEmpty && title.isEmpty && description.isEmpty && phoneNumber.isEmpty && price == 0
    }
}
extension Postable {
    
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
        get { keywords.sorted().compactMap { KeyWord(rawValue: $0) } }
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
}
