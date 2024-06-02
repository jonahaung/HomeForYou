//
//  AddressResult.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/2/23.
//
import Foundation
import MapKit
import Combine

final class AddressAutoComplete: NSObject, ObservableObject {

    @Published var results: [Address] = []
    @Published var searchableText = ""

    private lazy var localSearchCompleter: MKLocalSearchCompleter = { [weak self] in
        $0.pointOfInterestFilter = .excludingAll
        $0.delegate = self
        return $0
    }(MKLocalSearchCompleter())

    private var cancellables = Set<AnyCancellable>()

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
            .store(in: &cancellables)
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
        print(error)
    }
}

struct Address: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let postalCode: String

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

extension Address {
    init(_ completion: MKLocalSearchCompletion) {
        title = completion.title
        subtitle = completion.subtitle
        print(completion.description)
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
}
