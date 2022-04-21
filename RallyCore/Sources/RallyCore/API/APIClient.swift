//
//  APIClient.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RxSwift

public let SessionExpiredNotification = NSNotification.Name("SessionExpiredNotification")

public enum APIClientError: Error {
    case undefinedError
    case backendError(String)
    case failedStatus(Int)
}

public protocol APIClient {
    func post<Request: Encodable, Response: Decodable>(path: String, request: Request) -> Observable<Response>
    func post<Request: Encodable, Response: Decodable>(path: String, request: Request, timeoutInterval: TimeInterval) -> Observable<Response>
}
