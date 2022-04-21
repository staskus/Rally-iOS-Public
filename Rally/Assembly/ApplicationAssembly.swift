//
//  ApplicationAssembly.swift
//  Rally
//
//  Created by Povilas Staskus on 9/26/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import UIKit
import Swinject
import RallyCore
import RallyData

class ApplicationAssembly: Assembly {
    func assemble(container: Container) {
        assembleApplication(container: container)
    }

    private func assembleApplication(container: Container) {
        container.register(UIKit.UIWindow.self) { _ in
            UIWindow(frame: UIScreen.main.bounds)
        }.inObjectScope(.container)
    }
}
