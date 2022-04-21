//
//  ViewTimeRequestQueue.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation
import RxSwift

public protocol ViewTimeRequestQueue {
    func add(viewTime: ViewTime)
    func remove(questionNo: Int)
    func getAll() -> [ViewTime]
    func onAdded() -> Observable<[ViewTime]>
    func onRemoved() -> Observable<[ViewTime]>
    func exists(questionNo: Int) -> Bool
    func clear()
}
