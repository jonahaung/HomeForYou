//
//  Area.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

enum Area: String, StringViewRepresentable {
    
    case `Any`, Bishan, Bukit_Batok, Bukit_Merah, Bukit_Panjang, Bukit_Timah, Central_Water_Catchment, Changi, Changi_Bay, Choa_Chu_Kang, Clementi, Geylang, Novena, Pasir_Ris, Paya_Lebar, Seletar, Sembawang, Bedok, Boon_Lay, Sengkang, Serangoon, Ang_Mo_Kio, Tengah, Toa_Payoh, Western_Water_Catchment, Yishun, Downtown_Core, Marina_East, Newton, Orchard, Woodlands, Marina_South, Museum, Hougang, Juront_East, Lim_Chu_Kang, Mandai, Marine_Parade, North_Eastern_Islands, Pioneer, Punggol, Queenstown, South_Islands, Tuas, Jurong_West, Kallang, Simpang, Sungei_Kadut, Tampines, Western_Islands, Tanglin, Outram, River_Velly, Rocher, Singapore_River, Straits_View
    init?(
        string: String
    ) {
        let rawValue = string.components(
            separatedBy: " "
        ).map{
            $0.capitalized
        }.joined(
            separator: "_"
        )
        self.init(
            rawValue: rawValue
        )
    }
}
