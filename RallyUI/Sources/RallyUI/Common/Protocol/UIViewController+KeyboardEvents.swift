//
//  UIViewController+KeyboardEvents.swift
//  
//
//  Created by Povilas Staskus on 10/3/19.
//

import UIKit

extension UIViewController {
    func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppeared), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappeared), name: UIWindow.keyboardWillHideNotification, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
    }
    
    func unregisterKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func keyboardWillAppear(_ keyboardHeight: CGFloat) {
    }
    
    @objc
    func keyboardWillDisappear() {
    }
    
    @objc
    private func onKeyboardAppeared(_ sender: Notification) {
        guard let keyboardFrame = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue else {
            return
        }
        
        keyboardWillAppear(keyboardFrame.height)
    }
    
    @objc
    private func onKeyboardDisappeared(_ sender: Notification) {
        keyboardWillDisappear()
    }
    
    @objc
    private func closeKeyboard() {
        view.endEditing(true)
    }
}
