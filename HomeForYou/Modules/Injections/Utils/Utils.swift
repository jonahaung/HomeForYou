//
//  Utils.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import Foundation
import XUI

struct Utils {
    var dateFormatter = DateFormatter.medium
    var kmbFormatter = KMBFormatter()
    let timeAgoFormatter = TimeAgoFormatter()
    let urlHandler = DeepLinkHandler()
}
