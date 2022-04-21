//
//  Localizer.swift
//  
//
//  Created by Povilas Staskus on 11/6/19.
//

import Foundation

public prefix func ~ (key: String) -> String {
    return String.NSLocalizedStringWithDefault(key: key, comment: "")
}

public extension String {
    static func NSLocalizedStringWithDefault (key:String, comment:String) -> String {
        let message = NSLocalizedString(key, comment: comment)
        if message != key {
            return message
        }
        let language = "en"
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            return NSLocalizedString(key, comment: "")
        }
        let bundle = Bundle(path: path)
        if let forcedString = bundle?.localizedString(forKey: key, value: nil, table: nil) {
            return forcedString
        } else {
            return NSLocalizedString(key, comment: "")
        }
    }
}
