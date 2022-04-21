//
//  CommonTextField.swift
//  
//
//  Created by Povilas Staskus on 9/29/19.
//

import UIKit
import SnapKit

class CommonTextField: UIView {
    private let textField = NoActionUITextField()
    
    var placeholder: String? {
        get {
            return textField.attributedText?.string
        }
        
        set {
            guard let value = newValue else {
                textField.attributedPlaceholder = nil
                return
            }
            
            let attributedString = NSMutableAttributedString(string: value)
            let range = (value as NSString).range(of: value)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemGray, range: range)
            textField.attributedPlaceholder = attributedString
        }
    }
    
    var text: String? {
           get { return textField.text }
           set { textField.text = newValue }
       }
    
    var autocorrectionType: UITextAutocorrectionType {
        get { return textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        get { return textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }
    
    var isSecureTextEntry: Bool {
        get { return textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            textField.backgroundColor = backgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(textField.style(textFieldStyle))
        
        backgroundColor = textField.backgroundColor
        layer.cornerRadius = 8
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self).offset(-8)
            make.bottom.equalTo(self)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        textField.addTarget(target, action: action, for: event)
    }
}

extension CommonTextField {
    private func textFieldStyle(_ textField: UITextField) {
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.font = Theme.Font.small
        textField.textColor = Theme.primary
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
}

private class NoActionUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
