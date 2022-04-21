//
// QuestionAnswerResponse.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation
import RallyCore

public struct QuestionAnswerResponse: Codable, Equatable {
    public var result: QuestionAnswerResult
    
    public init(result: QuestionAnswerResult) {
        self.result = result
    }
}

public extension QuestionAnswerResponse {
    enum CodingKeys: String, CodingKey {
        case result = "Answer"
    }
}
