//
//  Utils+DateFormatter.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

extension DateFormatter {
    static let medium: DateFormatter = {
        $0.timeStyle = .none
        $0.dateStyle = .medium
        $0.locale = .autoupdatingCurrent
        return $0
    }(DateFormatter())

}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}

struct TimeAgoFormatter {
    let formatter: DateComponentsFormatter = {
        $0.unitsStyle = .full
        $0.allowedUnits = [.year, .month, .day, .hour, .minute]
        $0.zeroFormattingBehavior = .dropAll
        $0.maximumUnitCount = 1
        return $0
    }(DateComponentsFormatter())

    func string(from date: Date) -> String {
        String(format: formatter.string(from: date, to: .now) ?? "", locale: .current)
    }
}
