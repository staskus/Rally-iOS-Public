//
//  UserRepositoryMock.swift
//  
//
//  Created by Povilas Staskus on 11/23/19.
//

import Foundation
import RallyCore
import RxSwift

class UserRepositoryMock: UserRepository {
    var userToReturn: User!
    
    func login(name: String, password: String) -> Observable<User> {
        return .just(userToReturn)
    }
    
    func getUser() -> User? {
        return userToReturn
    }
    
    func logout() -> Observable<Void> {
        return .just(())
    }
}
