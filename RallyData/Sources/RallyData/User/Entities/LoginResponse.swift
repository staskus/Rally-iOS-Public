//
//  LoginResponse.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RallyCore

public struct LoginResponse: Decodable, Equatable {
    public var user: User
}

public extension LoginResponse {
    enum CodingKeys: String, CodingKey {
        case user = "User"
    }
}
