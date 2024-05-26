//
//  ServiceCell.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 1/2/24.
//

import SwiftUI
import XUI

struct ServiceCell: View {
    let service: Service
    var body: some View {
        _Label {
            SystemImage(service.icon)
                .foregroundStyle(.secondary)
        } right: {
            Text(service.title)
                .presentable(.init(service.screenType), .sheet)
        }
    }
}
