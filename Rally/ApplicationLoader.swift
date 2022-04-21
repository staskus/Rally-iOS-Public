//
//  ApplicationLoader.swift
//  Rally
//
//  Created by Povilas Staskus on 9/26/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

// swiftlint:disable force_cast
// swiftlint:disable force_try

import UIKit
import Swinject
import RallyCore
import RallyUI
import Firebase

final class ApplicationLoader {
    public let assembler: Assembler
    public var window: UIWindow?
    private weak var alert: UIViewController?

    init() {
        self.assembler = AssemblerFactory().create()
    }

    // Start the application loading sequence
    func start(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        setupLogger()
        loadRootViewController()
        
        NotificationCenter.default.addObserver(
            self,
            selector:
            #selector(startListeners),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector:
            #selector(stopListeners),
            name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector:
            #selector(showSessionExpiredAlert),
            name: SessionExpiredNotification, object: nil)
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        configureAppearance()
    }

    private func loadRootViewController() {
        window = assembler.resolver.resolve(UIKit.UIWindow.self)!
        window?.rootViewController = createRootViewController()
        window?.makeKeyAndVisible()
    }
    
    private func createRootViewController() -> UIViewController {
        let userRepository = assembler.resolver.resolve(UserRepository.self)!
        if let _ = userRepository.getUser() {
            let configurator = assembler.resolver.resolve(EventsConfigurator.self)!
            return BaseNavigationViewController(rootViewController: configurator.createViewController())
        } else {
            let configurator = assembler.resolver.resolve(LoginConfigurator.self)!
            return configurator.createViewController()
        }
    }
    
    @objc
    private func startListeners() {
        let connectionWatcher = assembler.resolver.resolve(ConnectionWatcher.self)!
        let answerQueueListener = assembler.resolver.resolve(QuestionAnswerRequestQueueListener.self)!
        
        connectionWatcher.startListening()
        answerQueueListener.startListening()
    }

    @objc
    private func stopListeners() {
        let connectionWatcher = assembler.resolver.resolve(ConnectionWatcher.self)!
        let answerQueueListener = assembler.resolver.resolve(QuestionAnswerRequestQueueListener.self)!
        
        connectionWatcher.stopListening()
        answerQueueListener.stopListening()
    }
    
    // TO DO
    private func setupLogger() {
        FirebaseApp.configure()
//        DDLog.add(DDASLLogger.sharedInstance)
    }
    
    private func configureAppearance() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
        UINavigationBar.appearance().largeTitleTextAttributes = attributes
    }
}

extension ApplicationLoader {
    @objc
    private func showSessionExpiredAlert() {
        guard alert == nil else { return }
        
        let alert = UIAlertController(
            title: ~"session_over_title",
            message: ~"session_over_details",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { [unowned self] _ in
                _ = self.assembler.resolver.resolve(UserRepository.self)!.logout()
                self.loadRootViewController()
        }))
        
        self.alert = alert
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
