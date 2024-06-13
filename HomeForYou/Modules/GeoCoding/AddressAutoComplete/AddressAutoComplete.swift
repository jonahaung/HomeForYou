//
//  AddressResult.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/2/23.
//
import Foundation
import MapKit
import Combine
import XUI

final class AddressAutoComplete: NSObject, ObservableObject {
    
    @Published var results: [Address] = []
    @Published var searchableText = ""
    
    private lazy var localSearchCompleter: MKLocalSearchCompleter = { [weak self] in
        $0.pointOfInterestFilter = .excludingAll
        $0.delegate = self
        return $0
    }(MKLocalSearchCompleter())
    
    private let cancelBag = CancelBag()
    
    override init() {
        super.init()
        $searchableText
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                if self.searchableText.isEmpty {
                    return
                }
                self.searchAddress(text)
            }
            .store(in: cancelBag)
    }
    
    private func searchAddress(_ searchableText: String) {
        localSearchCompleter.cancel()
        localSearchCompleter.queryFragment = searchableText
    }
}

extension AddressAutoComplete: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results.filter { $0.subtitle.lowercased().contains("singapore")}.map { Address($0) }
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        Log(error)
    }
}
