//
//  File.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

import Foundation
import RallyCore
import RxSwift

public struct ErrorResponse: Codable, Equatable {
    public var error: String
}

public extension ErrorResponse {
    enum CodingKeys: String, CodingKey {
        case error = "Error"
    }
}
 
public class APIClient: RallyCore.APIClient {
    private let baseUrl: String
    
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func post<Request: Encodable, Response: Decodable>(path: String, request: Request) -> Observable<Response> {
        return post(path: path, request: request, timeoutInterval: 0)
    }
    
    public func post<Request: Encodable, Response: Decodable>(path: String,
                                                              request: Request,
                                                              timeoutInterval: TimeInterval) -> Observable<Response> {
        let json = try? JSONSerialization.jsonObject(with: request.encoded(), options: .allowFragments)
        let jsonData = try? JSONSerialization.data(withJSONObject: json as Any)
        let url = URL(string: "\(baseUrl)\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.timeoutInterval = timeoutInterval
        
        return Observable<Response>.create { [unowned self] observable in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    observable.on(.error(error ?? APIClientError.undefinedError))
                    return
                }
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
                guard 200..<300 ~= statusCode else {
                    observable.on(.error(APIClientError.failedStatus(statusCode)))
                    return
                }
                
                do {
                    let response = try data.decoded() as Response
                    observable.on(.next(response))
                } catch {
                    if let errorResponse = (try? data.decoded() as ErrorResponse)?.error {
                        self.handleSessionExpiration(errorResponse)
                        observable.on(.error(APIClientError.backendError(errorResponse)))

                    } else {
                        observable.on(.error(error))
                    }
                }
            }
            
            task.resume()
            return Disposables.create {}
        }
        .do(onNext: { _ in
            print("POST SUCCESS: \(path)")
        }, onError: { error in
            print("POST FAIL \(path): \(error)")
        })
        .observeOn(MainScheduler.instance)
    }
}

// MARK: - Session Expiration

public extension APIClient {    
    private func handleSessionExpiration(_ errorResponse: String) {
        if errorResponse == "Session has expired!" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: SessionExpiredNotification, object: nil)
            }
        }
    }
}
