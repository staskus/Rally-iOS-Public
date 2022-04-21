//
//  QuestionAnswerRequestQueueListener.swift
//  
//
//  Created by Povilas Staskus on 11/17/19.
//

import Foundation

public protocol QuestionAnswerRequestQueueListener {
    func startListening()
    func stopListening()
}
