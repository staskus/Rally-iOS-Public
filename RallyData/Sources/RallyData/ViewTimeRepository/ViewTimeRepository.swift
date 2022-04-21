//
//  ViewTimeRepository.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation
import RxSwift
import RallyCore

public class ViewTimeRepository: RallyCore.ViewTimeRepository {
    private let apiClient: RallyCore.APIClient
    
    init(apiClient: RallyCore.APIClient) {
        self.apiClient = apiClient
    }
    
    public func sendViewTime(_ viewTime: ViewTime) -> Observable<ViewTimeResult> {
        let request = ViewTimeRequest(viewTime: viewTime)
        
        let response: Observable<ViewTimeResponse> = apiClient.post(
            path: "viewTime",
            request: request,
            timeoutInterval: 10
        )
        
        return response.map { $0.result }
    }
}
