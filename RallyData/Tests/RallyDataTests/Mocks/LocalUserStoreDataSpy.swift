//
//  LocalUserStoreDataSpy.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RallyCore
@testable import RallyData

class LocalUserStoreDataSpy: LocalUserStore {
    var userToReturn: User?
    var savedUser: User?
    
    func getUser() -> User? {
        return userToReturn
    }
    
    func save(user: User) {
        self.savedUser = user
    }
    
    func reset() {
    }
}
