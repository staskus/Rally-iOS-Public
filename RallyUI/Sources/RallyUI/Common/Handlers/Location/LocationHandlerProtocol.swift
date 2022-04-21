//
//  LocationHandlerProtocol.swift
//  
//
//  Created by Povilas Staskus on 11/3/19.
//

import Foundation
import RxSwift
import CoreLocation

public protocol LocationHandlerProtocol {
    func getLocation() -> Observable<CLLocation>
    func getCurrentLocation() -> CLLocation?
}
