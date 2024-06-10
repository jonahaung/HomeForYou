//
//  PostingData.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/5/24.
//

import Foundation
import XUI

struct MutablePost: Postable {
    var collectionPath: String { category.rawValue }
    var id: String
    var category: Category
    var autherID: String
    var author: PersonInfo
    
    var attachments = [XAttachment]()
    var roomURL: String?
    var title = String()
    var description = String()
    var phoneNumber = String()
    var price: Int = 0
    var occupant: Occupant?
    
    var mrt: String = String()
    var mrtDistance: Int = 0
    var area: Area = .Any
    var geoHash: String = String()
    var address: String = String()
    var postalCode: String = String()
    var latitude: Double = 0
    var longitude: Double = 0
    
    var propertyType = PropertyType.Any
    var roomType: RoomType?
    var furnishing: Furnishing?
    var beds = Bedroom.Any
    var baths = Bathroom.Any
    var floorLevel = FloorLevel.Any
    var tenantType: TenantType?
    var leaseTerm: LeaseTerm?
    var tenure: Tenure?
    var availableDate: Date = .now
    
    var features = [Feature]()
    var restrictions = [Restriction]()
    
    var status = PostStatus.Available
    var createdAt: Date = .now
    var keywords = [String]()
    var views = [String]()
    var favourites = [String]()
    
    var additional: [String: String]?
    
    init(category: Category, authorInfo: PersonInfo) {
        self.id = Post.createID()
        self.category = category
        self.autherID = authorInfo.id
        self.author = authorInfo
    }
    func updateUI() {
        
    }
}
