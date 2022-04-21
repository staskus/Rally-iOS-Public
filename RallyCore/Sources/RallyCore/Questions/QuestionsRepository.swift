//
//  QuestionsRepository.swift
//  
//
//  Created by Povilas Staskus on 10/29/19.
//

import Foundation
import RxSwift

public protocol QuestionsRepository {
    func getQuestions(byEventId eventId: String) -> Observable<Questions>
}

