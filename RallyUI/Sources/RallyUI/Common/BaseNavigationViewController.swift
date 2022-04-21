//
//  BaseNavigationViewController.swift
//  RallyUI
//
//  Created by Povilas Staskus on 9/28/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit

public class BaseNavigationViewController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = Theme.primary
    }
}
