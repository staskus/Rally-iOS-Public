//
//  QuestionsResponse.swift
//  
//
//  Created by Povilas Staskus on 10/29/19.
//

import Foundation
import RallyCore

public struct QuestionsResponse: Decodable, Equatable {
    public var questions: Questions
}

public extension QuestionsResponse {
    enum CodingKeys: String, CodingKey {
        case questions = "Questions"
    }
}
