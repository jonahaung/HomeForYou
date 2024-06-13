//
//  CurrentLocationReceiver.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 9/6/24.
//

import Foundation
import XUI
import CoreLocation

final class CurrentLocationReceiver: ObservableObject {
    
    private let publisher = CurrentLocationPublisher()
    private let cancelBag = CancelBag()
    @Published var coordinate: CLLocationCoordinate2D?
    
    func start() {
        cancelBag.cancel()
        publisher.publisher()
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .asyncSink { [weak self] value in
                await self?.setLocation(value)
            }
            .store(in: cancelBag)
        publisher.startUpdatingLocation()
    }
    @MainActor private func setLocation(_ location: CLLocation) {
        coordinate = location.coordinate
    }
    @MainActor func reset() {
        cancelBag.cancel()
        coordinate = nil
    }
}
