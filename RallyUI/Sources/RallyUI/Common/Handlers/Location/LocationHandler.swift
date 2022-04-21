//
//  LocationHandler.swift
//  
//
//  Created by Povilas Staskus on 11/3/19.
//

import Foundation
import CoreLocation
import RxSwift

final public class LocationHandler: NSObject, LocationHandlerProtocol {
    private let locationManager: CLLocationManager
    private var publishSubject = PublishSubject<CLLocation>()
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    public func getLocation() -> Observable<CLLocation> {
        return publishSubject
            .do(onSubscribe: startLocationUpdates, onDispose: stopLocationUpdates)
            .asObservable()
    }
    
    public func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
    private func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopLocationUpdates() {
        print("Stop location updates")
        locationManager.stopUpdatingLocation()
    }
}

extension LocationHandler: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            publishSubject.onNext(location)
        }
    }
}
