//
//  File.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation

public enum UserError: Error {
    case noSessionId
}

public struct LoginRequest: Codable, Equatable {
    public var login: Login
    
    public init (login: Login) {
        self.login = login
    }
}

public extension LoginRequest {
    enum CodingKeys: String, CodingKey {
        case login = "Login"
    }
}

public struct Login: Codable, Equatable {
    public var login: String
    public var password: String
    
    public init (login: String, password: String) {
        self.login = login
        self.password = password
    }
}

public extension Login {
    enum CodingKeys: String, CodingKey {
        case login = "Login"
        case password = "Password"
    }
}
