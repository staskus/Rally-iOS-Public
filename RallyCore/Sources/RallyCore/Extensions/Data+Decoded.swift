//
//  Data+Decoded.swift
//  RallyCore
//
//  Created by Povilas Staskus on 9/26/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import Foundation

public extension Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: self)
    }
}
