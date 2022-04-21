//
//  QuestionsRepository.swift
//  
//
//  Created by Povilas Staskus on 10/29/19.
//

import Foundation
import RxSwift
import RallyCore

public class QuestionsRepository: RallyCore.QuestionsRepository {
    private let apiClient: RallyCore.APIClient
    private let userRepository: RallyCore.UserRepository
    private let queue: RallyCore.QuestionAnswerRequestQueue
    
    init(apiClient: RallyCore.APIClient,
         userRepository: RallyCore.UserRepository,
         queue: RallyCore.QuestionAnswerRequestQueue) {
        self.apiClient = apiClient
        self.userRepository = userRepository
        self.queue = queue
    }
    
    public func getQuestions(byEventId eventId: String) -> Observable<Questions> {
        guard let sessionId = userRepository.getUser()?.sessionId else {
            return .error(UserError.noSessionId)
        }
        
        let questionsRequest = QuestionsRequest(
            questions: .init(
                sessionId: sessionId,
                eventId: eventId
            )
        )
        
        let questionsResponse: Observable<QuestionsResponse> = apiClient.post(path: "questions", request: questionsRequest)
        
        return questionsResponse
            .map { $0.questions }
            .do(onNext: { [weak self] in
                $0.questions.forEach { question in
                    self?.queue.remove(questionNo: question.no)
                }
            })
    }
}
