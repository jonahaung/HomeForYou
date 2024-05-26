//
//  Area.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

enum Area: String, StringViewRepresentable {
    case `Any`, Ang_Mo_Kio, Bedok, Bishan, Boon_Lay, Bukit_Batok, Bukit_Merah,
         Bukit_Panjang, Bukit_Timah, Central_Water_Catchment, Changi, Changi_Bay,
         Choa_Chu_Kang, Clementi, Downtown_Core, Geylang, Hougang, Jurong_East,
         Kallang, Lim_Chu_Kang, Mandai, Marina_East, Marina_South, Marine_Parade,
         Museum, Newton, North_Eaten_Islands, Novena, Orchard, Outram, Pasir_Ris,
         Paya_Lebar, Pioneer, Punggol, Queenstown, River_Valley, Rochor, Seletar,
         Sembawang, Senkang, Serangoon, Simpang, Singapore_River, Southern_Islands,
         Straits_View, Sungei_Kadut, Tempines, Tanglin, Tengah, Toa_Payoh, Tuas,
         Western_Islands, Western_Water_Catchment, Woodlands, Yishun

    init?(string: String) {
        let rawValue = string.components(separatedBy: " ").joined(separator: "_")
        self.init(rawValue: rawValue)
    }
}
