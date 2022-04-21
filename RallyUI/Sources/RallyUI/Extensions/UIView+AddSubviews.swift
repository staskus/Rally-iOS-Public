//
//  UIView+AddSubviews.swift
//  RallyUI
//
//  Created by Povilas Staskus on 10/1/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func addSubviews(_ subViews: UIView...) -> UIView {
        return addSubviews(subViews)
    }

    @discardableResult
    func addSubviews(_ subViews: [UIView]) -> UIView {
        for sv in subViews {
            addSubview(sv)
        }
        return self
    }
}
