//
//  Posting.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/6/24.
//

import Foundation

enum Posting {
    enum PostingFlow: String, Identifiable, CaseIterable {
        var id: String { rawValue }
        case attachments, details, description
    }
}
