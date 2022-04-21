//
//  User.swift
//  RallyCore
//
//  Created by Povilas Staskus on 9/23/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import Foundation

public struct User: Codable, Equatable {
    public var login: String
    public var sessionId: String?
}

public extension User {
    enum CodingKeys: String, CodingKey {
        case login = "Login"
        case sessionId = "SessionID"
    }
}
