//
//  QuestionAnswerRepository.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation
import RxSwift

public protocol QuestionAnswerRepository {
    func answer(_ answer: QuestionAnswer) -> Observable<QuestionAnswerResult>
}
