//
//  PermissionType.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/7/23.
//

import Foundation
import SFSafeSymbols
import Photos
import FireAuthManager

public enum AppPermissionType {
    
    case mediaLibrary
    case currentLocation
    
    public enum Status {
        case granted, notDetermined, restricted
    }
    public var status: Status {
        switch self {
        case .mediaLibrary:
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
                .status
        case .currentLocation:
            let locationManager = CLLocationManager()
            return locationManager.authorizationStatus.status
        }
    }
}

public extension AppPermissionType {
    var title: String {
        switch self {
        case .mediaLibrary:
            return "Media Library"
        case .currentLocation:
            return "Current Location"
        }
    }
    var infoText: String {
        switch self {
        case .mediaLibrary:
            return "Allow us you access your photo library so that you can upload your photo along with your post"
        case .currentLocation:
            return "Allow us you access your current location when in use so that we could help you find the best deals around you."
        }
    }
    var buttonText: String {
        switch self {
        case .mediaLibrary, .currentLocation:
            return "Grant Permissivon"
        }
    }
    
    var symbol: SFSymbol {
        switch self {
        case .mediaLibrary:
            return .photoOnRectangleAngled
        case .currentLocation:
            return .locationViewfinder
        }
    }
}
private extension PHAuthorizationStatus {
    var status: AppPermissionType.Status {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .authorized, .limited:
            return .granted
        case .denied, .restricted:
            return .restricted
        @unknown default:
            return .restricted
        }
    }
}

private extension CLAuthorizationStatus {
    var status: AppPermissionType.Status {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .restricted
        case .authorizedAlways, .authorizedWhenInUse, .restricted:
            return .granted
        @unknown default:
            return .restricted
        }
    }
}
