//
//  QuestionAnswerRepository.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation
import RxSwift
import RallyCore

public class QuestionAnswerRepository: RallyCore.QuestionAnswerRepository {
    private let apiClient: RallyCore.APIClient
    
    init(apiClient: RallyCore.APIClient) {
        self.apiClient = apiClient
    }
    
    public func answer(_ answer: QuestionAnswer) -> Observable<QuestionAnswerResult> {
        let questionAnswerRequest = QuestionAnswerRequest(answer: answer)
        
        let questionAnswerResponse: Observable<QuestionAnswerResponse> = apiClient.post(
            path: "answer",
            request: questionAnswerRequest
        )
        
        return questionAnswerResponse.map { $0.result }
    }
}
