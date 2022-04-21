//
//  Style.swift
//  RallyUI
//
//  Created by Povilas Staskus on 11/20/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit

struct Style {
    struct Button {
        static func main(_ button: UIButton) {
            button.setBackgroundColor(Theme.secondary, forUIControlState: .normal)
            button.setBackgroundColor(Theme.secondary.withAlphaComponent(0.65), forUIControlState: .highlighted)
            button.setTitleColor(Theme.primary, for: .normal)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 8
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        
        static func link(_ button: UIButton) {
            button.setBackgroundColor(.clear, forUIControlState: .normal)
            button.setTitleColor(Theme.primary, for: .normal)
            button.setTitleColor(Theme.primary.withAlphaComponent(0.65), for: .highlighted)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
    }
    
    struct Image {
        static func scaleAspectFit(_ image: UIImageView) {
            image.contentMode = .scaleAspectFit
        }
    }
    
    struct Label {
        static func small(_ label: UILabel) {
            label.font = Theme.Font.small
            label.textColor = Theme.primary
        }
        
        static func medium(_ label: UILabel) {
            label.font = Theme.Font.medium
            label.textColor = Theme.primary
        }
        
        static func large(_ label: UILabel) {
            label.font = Theme.Font.large
            label.textColor = Theme.primary
        }
        
        static func multiline(_ label: UILabel) {
            label.numberOfLines = 0
        }
        
        static func center(_ label: UILabel) {
            label.textAlignment = .center
        }
    }
}
