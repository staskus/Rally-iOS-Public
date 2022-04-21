//
//  Questions.swift
//  RallyCore
//
//  Created by Povilas Staskus on 9/28/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import Foundation

public struct Questions: Decodable, Equatable {
    public var eventId: String
    public var activationTime: Date
    public var deactivationTime: Date
    public var questions: [Question]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventId = try container.decode(String.self, forKey: .eventId)
        activationTime = try container.decode(Date.self, forKey: .activationTime)
        deactivationTime = try container.decode(Date.self, forKey: .deactivationTime)
        questions = try container.decode([Question].self, forKey: .questions)
    }
}

public extension Questions {
    enum CodingKeys: String, CodingKey {
        case eventId = "EventID"
        case activationTime = "ActivationTime"
        case deactivationTime = "DeactivationTime"
        case questions = "Questions"
    }
}

public struct Question: Decodable, Equatable {
    public var no: Int
    public var name: String
    public var latitude: String
    public var longitude: String
    public var radius: Double
    public var text: String
    public var type: QuestionType
    public var answers: [Answer]?
    public var state: AnsweredQuestionState
    public var imageUrl: String?
    public var isAnswerableOnce: Bool
    public var isSavingFirstSeenTime: Bool
    public var firstSeenTimestamp: Date?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        no = try container.decode(Int.self, forKey: .no)
        name = try container.decode(String.self, forKey: .name)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        radius = try container.decode(Double.self, forKey: .radius)
        text = try container.decode(String.self, forKey: .text)
        type = try container.decode(QuestionType.self, forKey: .type)
        answers = try? container.decodeIfPresent([Answer].self, forKey: .answers)
        state = try container.decode(AnsweredQuestionState.self, forKey: .state)
        imageUrl = try? container.decodeIfPresent(String.self, forKey: .imageUrl)
        isAnswerableOnce = (try? container.decodeIfPresent(Bool.self, forKey: .isAnswerableOnce)) ?? false
        isSavingFirstSeenTime = (try? container.decodeIfPresent(Bool.self, forKey: .isSavingFirstSeenTime)) ?? false
        firstSeenTimestamp = (try? container.decodeIfPresent(Date.self, forKey: .firstSeenTimestamp))
    }
}

public extension Question {
    enum QuestionType: String, Decodable, Equatable {
        case choice, text, number, decimal
    }
}

public extension Question {
    enum CodingKeys: String, CodingKey {
        case no = "QNo"
        case name = "QName"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case radius = "Radius"
        case text = "Text"
        case type = "Type"
        case answers = "Answers"
        case state = "QAnswered"
        case imageUrl = "QImage"
        case isAnswerableOnce = "QAnswerOnce"
        case isSavingFirstSeenTime = "QViewTiming"
        case firstSeenTimestamp = "QSeenTimestamp"
    }
}

public struct Answer: Decodable, Equatable {
    public var no: Int
    public var type: Answer.`Type`

    public init(from decoder: Decoder) throws {
         let values = try decoder.container(keyedBy: Answer.CodingKeys.self)
         if let value = try? values.decode(String.self, forKey: Answer.CodingKeys.value) {
             type = .text(value)
         } else {
            let imageUrl = try values.decode(String.self, forKey: Answer.CodingKeys.image)
            type = .image(imageUrl)
         }

        no = try values.decode(Int.self, forKey: Answer.CodingKeys.no)
     }
}

public extension Answer {
    enum `Type`: Equatable {
        case text(String)
        case image(String)
    }
}

public extension Answer {
    enum CodingKeys: String, CodingKey {
        case no = "ANo"
        case mode = "Type"
        case value = "Value"
        case image = "AImage"
    }
}

public struct AnsweredQuestionState: Decodable, Equatable {
    public var state: Bool
    public var timestamp: Date?
    public var value: String?
    
    public var isAnswered: Bool {
        return state
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        state = try container.decode(Bool.self, forKey: .state)
        timestamp = try? container.decodeIfPresent(Date.self, forKey: .timestamp)
        value = try? container.decodeIfPresent(String.self, forKey: .value)
    }
}

public extension AnsweredQuestionState {
    enum CodingKeys: String, CodingKey {
        case state = "State"
        case timestamp = "Timestamp"
        case value = "Value"
    }
}
