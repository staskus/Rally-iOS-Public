//
//  Encodable+Encoded.swift
//  RallyCore
//
//  Created by Povilas Staskus on 9/26/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import Foundation

public extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}
