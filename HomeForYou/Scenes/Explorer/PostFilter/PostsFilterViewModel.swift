//
//  PostsFilterViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI
import XUI


final class PostsFilterViewModel: ObservableObject {
    
    @Published var quries: [PostQuery] = []
    @Published var isPriceSearch = false
    @Published var priceRange: ClosedRange<Int> = 0...10000
    let category = Category.current
    
    func allCasesSting(for key: PostKey) -> [String] {
        switch key {
        case .occupant:
            return Occupant.allCases.map{ $0.rawValue }
        case .area:
            return Area.allCases.map{ $0.rawValue }
        case .mrt:
            return MRT.allValueStrings
        case .propertyType:
            return PropertyType.allCases.map{ $0.rawValue }
        case .roomType:
            return RoomType.allCases.map{ $0.rawValue }
        case .furnishing:
            return Furnishing.allCases.map{ $0.rawValue }
        case .beds:
            return Bedroom.allCases.map{ $0.rawValue }
        case .baths:
            return Bathroom.allCases.map{ $0.rawValue }
        case .floorLevel:
            return FloorLevel.allCases.map{ $0.rawValue }
        case .tenantType:
            return TenantType.allCases.map{ $0.rawValue }
        case .leaseTerm:
            return LeaseTerm.allCases.map{ $0.rawValue }
        case .tenure:
            return Tenure.allCases.map{ $0.rawValue }
        case .features:
            return Feature.allCases.map{ $0.rawValue }
        case .restrictions:
            return Restriction.allCases.map{ $0.rawValue }
        case .status:
            return PostStatus.allCases.map{ $0.rawValue }
        case .keywords:
            return KeyWord.allCases.map{ $0.keyValueString }
        default:
            fatalError()
        }
    }
    
    func bindableValue(for key: PostKey) -> Binding<String> {
        let query = self.quries.first(where: { $0.key == key })
        return .init {
            return query?.value ?? ""
        } set: { [weak self] newValue in
            guard let self else { return }
            
            if var query, let i = self.quries.firstIndex(of: query) {
                guard !newValue.isWhitespace else {
                    self.quries.remove(at: i)
                    return
                }
                query.value = newValue
                self.quries[i] = query
            } else {
                self.quries.append(.init(key, newValue))
            }
            self.objectWillChange.send()
        }
    }
    
    func getBindableModels<T: RawRepresentable>(for key: PostKey) -> Binding<[T]> where T.RawValue == String {
        return .init {
            if let strings = self.quries.first(where: { $0.key == key })?.value.components(separatedBy: "|"), strings.isEmpty == false {
                return strings.compactMap{ T(rawValue: $0) }.removeDuplicates { one, two in
                    one.rawValue == two.rawValue
                }
            }
            return []
        } set: { [weak self] newValue in
            guard let self else { return }
            if let index = self.quries.firstIndex(where: { $0.key == key }) {
                self.quries.remove(at: index)
            }
            guard !newValue.isEmpty else {
                return
            }
            let value = newValue.map{ $0.rawValue }.sorted().joined(separator: "|")
            let query = PostQuery(key, value)
            self.quries.append(query)
            self.objectWillChange.send()
        }
    }
    @Published var restictions = [Restriction]()
}
