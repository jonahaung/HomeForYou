//
//  Constanst.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/8/23.
//

import Foundation

enum K {
    struct Posting {
        static let Number_Of_Max_Attachments_Allowed = 8
    }
    
    struct Image {
        static let imageUploadWidth = 600.0
        static let imageUploadQuality = 0.5
        static let thumbnilImageWidth: CGFloat = 300
    }
    
    enum Defaults: String {
        case currentUserRegion
        case currentCategory
        case currentSearchScope
    }
}
