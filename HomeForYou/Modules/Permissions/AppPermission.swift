//
//  AppPermission.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 19/5/24.
//

import SwiftUI
import Photos
import CoreLocation
import XUI

@Observable class AppPermission: NSObject {
    
    @ObservationIgnored let permissionType: AppPermissionType
    var status: AppPermissionType.Status
    private var locationManager: CLLocationManager?
    
    init(_ type: AppPermissionType) {
        self.permissionType = type
        self.status = type.status
        super.init()
    }
    
    func onRequest() {
        switch permissionType {
        case .mediaLibrary:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] value in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.updateStatus()
                }
            }
        case .currentLocation:
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    @MainActor func updateStatus() {
        status = permissionType.status
    }
}

extension AppPermission: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.updateStatus()
        }
    }
}
