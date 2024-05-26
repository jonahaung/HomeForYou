//
//  LocationManager.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/4/23.
//

import Foundation
import MapKit
import XUI

final class LocationManager: NSObject {

    var manager: CLLocationManager = {
        $0.pausesLocationUpdatesAutomatically = true
        $0.desiredAccuracy = kCLLocationAccuracyBest
        return $0
    }(CLLocationManager())
    
    var authorizationStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }
    override init() {
        super.init()
        manager.delegate = self
    }
    @MainActor
    func start() {
        stop()
        if authorizationStatus == .notDetermined {
            requestWhenInUse { [weak self] in
                DispatchQueue.main.async {
                    self?.manager.startUpdatingLocation()
                }
            }
        } else {
            manager.startUpdatingLocation()
        }
    }

    func stop() {
        manager.stopUpdatingLocation()
    }
    private var onRequestWhenInUse: (() -> Void)?
    @MainActor
    func requestWhenInUse(_ completion: @escaping () -> Void) {
        onRequestWhenInUse = completion
        manager.requestWhenInUseAuthorization()
    }
    private var onGetCurrrentLocation: ((CLLocationCoordinate2D) -> Void)?
    @MainActor
    func getCurrentLocation(_ completion: @escaping (CLLocationCoordinate2D) -> Void) {
        onGetCurrrentLocation = completion
        if authorizationStatus == .notDetermined {
            requestWhenInUse { [weak self] in
                DispatchQueue.main.async {
                    self?.manager.startUpdatingLocation()
                }
            }
        } else {
            manager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Paused")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.stop()
        onGetCurrrentLocation?(location.coordinate)
//        Task {
//            do {
//                let locationInfo = try await GeoCoder.createLocationInfo(from: location)
//                await updateLocation(locationInfo)
//            } catch {
//                await updateLocation(nil)
//            }
//        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onRequestWhenInUse?()
    }
}
