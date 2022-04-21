//
//  APIClientMock.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RxSwift
import RallyCore

class APIClientMock: RallyCore.APIClient {
    var responseToReturn: Observable<Any>!
    
    func get<Response>(path: String) -> Observable<Response> where Response : Decodable {
        return responseToReturn!
            .map { $0 as! Response }
    }
    
    func post<Request, Response>(path: String, request: Request) -> Observable<Response> where Request : Encodable, Response : Decodable {
        return responseToReturn!
            .map { $0 as! Response }
    }
    
    func post<Request, Response>(path: String, request: Request, timeoutInterval: TimeInterval) -> Observable<Response> where Request : Encodable, Response : Decodable {
        return responseToReturn!
            .map { $0 as! Response }
    }
}

class APIClientSpy: APIClientMock {
    var getPathCalled: String?
    var postPathCalled: String?
    var postRequestCalled: Any?
    
    override func get<Response>(path: String) -> Observable<Response> where Response : Decodable {
        getPathCalled = path
        return super.get(path: path)
    }
    
    override func post<Request, Response>(path: String, request: Request) -> Observable<Response> where Request : Encodable, Response : Decodable {
        postPathCalled = path
        postRequestCalled = request
        return super.post(path: path, request: request)
    }
}
