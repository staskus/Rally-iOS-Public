//
//  RxSwift+ToBlockingFirst.swift
//  
//
//  Created by Povilas Staskus on 9/28/19.
//

//import Foundation
//import RxSwift
//import RxCocoa
//
//extension SharedSequence {
//    func toBlockingFirst() -> Element? {
//        guard let items = try? self.asObservable().take(1).toBlocking(timeout: 1.0).toArray() else {
//            return nil
//        }
//        
//        return items.first
//    }
//}
//
//extension Observable {
//    func toBlockingFirst() -> Element? {
//        guard let items = try? self.take(1).toBlocking(timeout: 1.0).toArray() else {
//            return nil
//        }
//        
//        return items.first
//    }
//}
