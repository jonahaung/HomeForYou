//
//  PersonCell.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/4/23.
//

import SwiftUI
import XUI

struct PersonCell: View {
    
    @StateObject private var model: PersonDetails
    
    init(_ id: String) {
        _model = .init(wrappedValue: PersonDetails(id))
    }
    @ViewBuilder
    var body: some View {
        HStack {
            PersonAvatarView(personInfo: model.person.personInfo, size: 35)
            Text(model.person.name)
            //                ._tapToPush {
            //                    PersonDetailsView(model: model.person.personInfo)
            //                }
        }
    }
}
