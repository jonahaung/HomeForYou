//
//  LocationMapItem++.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/24.
//

import Foundation
extension Post {
    var locationMapItem: LocationMapItem { .init(title: self._location.address.postal, subtitle: self._location.geoInfo.geoHash, coordinate: .init(latitude: latitude, longitude: longitude)) }
}
extension MRT {
    var locationMapItem: LocationMapItem { .init(title: name, subtitle: symbol.first!.code, coordinate: .init(latitude: latitude, longitude: longitude), color: symbol.first?.swiftColor)}
}
