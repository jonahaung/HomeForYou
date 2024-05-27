//
//  LocationPublisher.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/5/24.
//

import Foundation
import MapKit
import XUI
import Combine

class LocationPublisher: NSObject {
    
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    private let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    private var cancelBag = CancelBag()
    private let manager: CLLocationManager = {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        return $0
    }(CLLocationManager())
}
extension LocationPublisher {
    func startRequestingWhenInUseAuthorization() {
        manager.delegate = self
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if manager.authorizationStatus != .denied {
            authorizationSubject.send(.authorizedWhenInUse)
        }
    }
    func startUpdatingLocation() {
        manager.delegate = self
        switch manager.authorizationStatus {
        case .notDetermined:
            authorizationPublisher()
                .removeDuplicates()
                .debounce(for: 0.3, scheduler: RunLoop.main)
                .sink { [weak self] value in
                    guard let self else { return }
                    switch value {
                    case .authorizedAlways, .authorizedWhenInUse:
                        self.manager.startUpdatingLocation()
                    default:
                        break
                    }
                }
                .store(in: cancelBag)
            startRequestingWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    func stopUpdatingLocation() {
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
}
extension LocationPublisher {
    func locationPublisher() -> AnyPublisher<CLLocation, Never> {
        locationSubject
            .eraseToAnyPublisher()
    }
    func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
        Just(manager.authorizationStatus)
            .merge(with: authorizationSubject.compactMap { $0 })
            .eraseToAnyPublisher()
    }
}
extension LocationPublisher: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            locationSubject.send(last)
            stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationSubject.send(status)
    }
}
