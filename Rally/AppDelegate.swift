//
//  AppDelegate.swift
//  Rally
//
//  Created by Povilas Staskus on 9/23/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import UIKit
import RxSwift
import RallyCore
import RallyData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? {
        get { return applicationLoader.window }
        set { applicationLoader.window = newValue }
    }
    
    private let applicationLoader = ApplicationLoader()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        applicationLoader.start(launchOptions: launchOptions)
        
        return true
    }
}
