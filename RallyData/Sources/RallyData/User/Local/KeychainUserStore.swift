//
//  File.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RallyCore
import KeychainSwift

public class KeychainUserStore: LocalUserStore {
    private let keychain = KeychainSwift()
    private let key = "user.key"
    
    public func getUser() -> User? {
        guard let data = keychain.getData(key) else {
            return nil
        }
        
        return try? PropertyListDecoder().decode(User.self, from: data)
    }
    
    public func save(user: User) {
        keychain.set(try? PropertyListEncoder().encode(user), forKey: key)
    }
    
    public func reset() {
        keychain.set(nil, forKey: key)
    }
}
