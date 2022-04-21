//
//  QuestionAnswerRequestQueue.swift
//  
//
//  Created by Povilas Staskus on 11/17/19.
//

import Foundation
import RxSwift

public protocol QuestionAnswerRequestQueue {
    func add(answer: QuestionAnswer)
    func remove(questionNo: Int)
    func getAll() -> [QuestionAnswer]
    func onAdded() -> Observable<[QuestionAnswer]>
    func onRemoved() -> Observable<[QuestionAnswer]>
    func exists(questionNo: Int) -> Bool
    func clear()
}
