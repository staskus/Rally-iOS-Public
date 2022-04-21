//
//  File.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation

public struct LoginRequest {
    public static func with(_ loginData: String) -> String {
        return """
        {"Login":\(loginData)}
        """
    }
    public struct Login {
        public static let valid =
            """
            {"Login":"email@gmail.com","Password":"qwe123"}
            """
    }
}

public struct LoginResponse {
    public static func with(_ userData: String) -> String {
        return """
        {
        "User": \(userData)
        }
        """
    }
    public struct User {
        public static let valid =
            """
            {"Login":"email@gmail.com","SessionID":"weytrt56-shfd765-suyftsud567-sdiufys657"}
            """
        public static let validAdditionalField =
            """
            {"Login":"email@gmail.com","SessionID":"weytrt56-shfd765-suyftsud567-sdiufys657"}
            """
        public static let invalid =
        """
        {"Logiin":"email@gmail.com","SessionID":"weytrt56-shfd765-suyftsud567-sdiufys657"}
        """
    }
}


public struct QuestionAnswerRequest {
    public static func with(_ answerData: String) -> String {
        return """
        {"Answer":\(answerData)}
        """
    }
    public struct QuestionAnswer {
        public static let valid =
            """
            {"SessionID":"weytrt56-shfd765-suyftsud567-sdiufys657","EventId":"9877","QNo":2,"ANo":2,"ASubmitTimestamp":"2019-10-28T19:59:31+0000","ASendTimestamp":"2019-10-28T19:59:31+0000"}
            """
    }
}

public struct QuestionAnswerResponse {
    public static func with(_ answerData: String) -> String {
        return """
        {"Answer":\(answerData)}
        """
    }
    public struct QuestionAnswerResult {
        public static let valid =
            """
            {"SessionID":"weytrt56-shfd765-suyftsud567-sdiufys657","EventId":"9877","QNo":2,"Result":"Ok"}
            """
    }
}
