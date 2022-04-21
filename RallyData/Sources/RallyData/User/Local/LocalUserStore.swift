//
//  LocalUserStore.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RallyCore

public protocol LocalUserStore {
    func getUser() -> User?
    func save(user: User)
    func reset()
}

