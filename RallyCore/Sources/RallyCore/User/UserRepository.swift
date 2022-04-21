//
//  UserRepository.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RxSwift

public protocol UserRepository {
    func login(name: String, password: String) -> Observable<User>
    func getUser() -> User?
    func logout() -> Observable<Void>
}
