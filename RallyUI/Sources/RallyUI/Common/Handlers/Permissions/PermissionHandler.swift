//
//  PermissionHandler.swift
//  
//
//  Created by Povilas Staskus on 11/3/19.
//

import UIKit
import CoreLocation
import AVKit
import Photos

public protocol PermissionHandlerDelegate: class {
    func locationPermissionStatusChanged()
}

final public class PermissionHandler: NSObject {
    fileprivate let locationManager: CLLocationManager
    fileprivate var completion: ((Bool) -> ())?
    public weak var delegate: PermissionHandlerDelegate?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: Location
    
    func askForLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func canAskLocationPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status != .denied && status != .authorizedWhenInUse && status != .authorizedAlways
    }
    
    func isLocationDenied() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .denied: return true
            case .authorizedAlways, .authorizedWhenInUse: return false
            default: return false
            }
        } else {
            print("Location services are not enabled")
        }
        return true
    }
}

extension PermissionHandler: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationPermissionStatusChanged()
    }
}
