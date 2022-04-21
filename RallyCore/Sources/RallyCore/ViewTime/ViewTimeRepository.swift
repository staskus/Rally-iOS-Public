//
//  ViewTimeRepository.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation
import RxSwift

public protocol ViewTimeRepository {
    func sendViewTime(_ viewTime: ViewTime) -> Observable<ViewTimeResult>
}
