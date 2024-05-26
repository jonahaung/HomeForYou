//
//  LocalSearchWorker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 12/8/23.
//

import Foundation
import MapKit

final class LocalSearchWorker: NSObject {
    private lazy var localSearchCompleter: MKLocalSearchCompleter = { [weak self] in
        $0.pointOfInterestFilter = .excludingAll
        $0.delegate = self
        return $0
    }(MKLocalSearchCompleter())
    
    private var completion: (([KeyWord]) -> Void)?
    
    func search(_ text: String, completion: @escaping ([KeyWord]) -> Void) {
        self.completion = completion
        localSearchCompleter.cancel()
        localSearchCompleter.queryFragment = text
    }
}

extension LocalSearchWorker: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.filter {
            $0.subtitle.lowercased().contains("singapore")
        }
            .map { $0.title + ", " + $0.subtitle }
        completion?(results.map { .init(.address, $0)})
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
