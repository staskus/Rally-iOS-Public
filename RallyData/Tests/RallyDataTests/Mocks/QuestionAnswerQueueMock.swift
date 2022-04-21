//
//  QuestionAnswerQueueMock.swift
//  
//
//  Created by Povilas Staskus on 11/23/19.
//

import Foundation
import RallyCore
import RxSwift

class QuestionAnswerQueueMock: QuestionAnswerRequestQueue {
    func add(answer: QuestionAnswer) {
    }
    
    func remove(questionNo: Int) {
    }
    
    func getAll() -> [QuestionAnswer] {
        return []
    }
    
    func onAdded() -> Observable<[QuestionAnswer]> {
        return .just([])
    }
    
    func onRemoved() -> Observable<[QuestionAnswer]> {
        return .just([])
    }
    
    func exists(questionNo: Int) -> Bool {
        return false
    }
    
    func clear() {
    }
}
