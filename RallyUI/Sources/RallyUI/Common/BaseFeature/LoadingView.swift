//
//  LoadingView.swift
//  RallyUI
//
//  Created by Povilas Staskus on 9/27/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit
import JGProgressHUD

class LoadingView: UIView {
    private let hud: JGProgressHUD

    init() {
        hud = JGProgressHUD(style: .light)
        super.init(frame: .zero)
        hud.show(in: self, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
