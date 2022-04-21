//
//  Theme.swift
//  RallyUI
//
//  Created by Povilas Staskus on 9/28/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit

struct Theme {
    static let primary = UIColor(red: 40/255, green: 49/255, blue: 61/255, alpha: 1.0)
    static let primaryLight = Theme.primary.withAlphaComponent(0.9)
    static let secondary = UIColor(red: 156/255, green: 209/255, blue: 34/255, alpha: 1.0)
    static let backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 247/255, alpha: 1.0)
    static let separatorColor = Theme.primaryLight.withAlphaComponent(0.2)
    
    struct Font {
        static let large = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let medium = UIFont.systemFont(ofSize: 24, weight: .regular)
        static let small = UIFont.systemFont(ofSize: 18, weight: .regular)
        static let extraSmall = UIFont.italicSystemFont(ofSize: 14)
    }
    
    struct Padding {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = -16
        static let all: UIEdgeInsets = UIEdgeInsets(top: 0, left: leading, bottom: 0, right: trailing)
    }
}
