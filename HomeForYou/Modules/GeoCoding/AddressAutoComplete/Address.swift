//
//  Address.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/6/24.
//

import Foundation
import MapKit
import XUI

struct Address: Identifiable {
    
    let id = UUID()
    let title: String
    let subtitle: String
    let postalCode: String
}

extension Address {
    init(_ completion: MKLocalSearchCompletion) {
        title = completion.title
        subtitle = completion.subtitle
        Log(completion.description)
        let components = subtitle.components(separatedBy: ",").map { $0.trimmed }
        var code = ""
        for each in components {
            if each.contains("Singapore "), let possible = each.components(separatedBy: "Singapore ").last, !possible.isEmpty {
                code = possible
                break
            }
        }
        postalCode = code
    }
    
    var fullAddress: String {
        var string = title
        if !subtitle.isEmpty {
            if string.isEmpty {
                string = subtitle
            } else {
                string.append(", \(subtitle)")
            }
        }
        return string.trimmed
    }
}
