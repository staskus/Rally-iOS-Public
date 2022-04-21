//
//  MockAPIClient.swift
//  
//
//  Created by Povilas Staskus on 10/28/19.
//

import Foundation
import RxSwift
import RallyCore

public class MockAPIClient: APIClient {
    override public func post<Request, Response>(path: String, request: Request) -> Observable<Response> where Request : Encodable, Response : Decodable {
        guard let urlPath = url(for: path),
            let data = try? Data(contentsOf: URL(fileURLWithPath: urlPath).absoluteURL) else {
                return super.post(path: path, request: request)
        }
        
        return .just(try! data.decoded() as Response)
    }
    
    public override func post<Request, Response>(path: String, request: Request, timeoutInterval: TimeInterval) -> Observable<Response> where Request : Encodable, Response : Decodable {
        return post(path: path, request: request)
    }
    
    private func url(for path: String) -> String? {
        if path.contains("events") {
            return Bundle.main.path(forResource: "EventsMock", ofType: "json")
        }
        
        if path.contains("login") {
            return Bundle.main.path(forResource: "LoginMock", ofType: "json")
        }
        
        if path.contains("questions") {
            return Bundle.main.path(forResource: "QuestionsMock", ofType: "json")
        }
        
        if path.contains("viewTime") {
            return Bundle.main.path(forResource: "ViewTimeMock", ofType: "json")
        }
        
        return nil
    }
}
