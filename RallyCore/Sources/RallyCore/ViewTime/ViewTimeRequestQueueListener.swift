//
//  ViewTimeRequestQueueListener.swift
//  
//
//  Created by Povilas Staskus on 2020-05-27.
//

import Foundation

public protocol ViewTimeRequestQueueListener {
    func startListening()
    func stopListening()
}
