//
//  UserRepository.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RxSwift
import RallyCore

public class UserRepository: RallyCore.UserRepository {
    private let apiClient: RallyCore.APIClient
    private let localStore: LocalUserStore
    private let localEventStore: LocalEventStore
    private let queue: RallyCore.QuestionAnswerRequestQueue
    
    init(apiClient: RallyCore.APIClient,
         localStore: LocalUserStore,
         localEventStore: LocalEventStore,
         queue: RallyCore.QuestionAnswerRequestQueue) {
        self.apiClient = apiClient
        self.localStore = localStore
        self.localEventStore = localEventStore
        self.queue = queue
    }
    
    public func login(name: String, password: String) -> Observable<User> {
        let loginRequest = LoginRequest(
            login: Login(
                login: name,
                password: password
            )
        )
        
        let loginResponse: Observable<LoginResponse> = apiClient.post(path: "login", request: loginRequest)
        return loginResponse
            .map { $0.user }
            .do(onNext: {
                print("SESSION ID: \($0.sessionId ?? "")")
                self.localStore.save(user: $0)
            })
    }
    
    public func getUser() -> User? {
        return localStore.getUser()
    }
    
    public func logout() -> Observable<Void> {
        localStore.reset()
        localEventStore.reset()
        queue.clear()
        
        guard let sessionId = getUser()?.sessionId else {
            return .just(())
        }
        
        let logoutRequest = LogoutRequest(
            logoutSession: LogoutSession(
                sessionId: sessionId
            )
        )
        
        let logoutResponse: Observable<LogoutResponse> = apiClient.post(path: "logout", request: logoutRequest)
        
        return logoutResponse
            .map { $0.logoutSession }
            .map { logout in
                guard logout.isAccepted else {
                    throw LogoutError.unknown
                }
                
                return ()
            }
    }
}
