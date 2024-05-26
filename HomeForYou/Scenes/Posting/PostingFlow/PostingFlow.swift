//
//  PostingFlow.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/5/24.
//

import Foundation

enum PostingFlow: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    case attachments, details, description
}
