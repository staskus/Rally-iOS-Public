//
//  AnswerTimerCircle.swift
//  
//
//  Created by Povilas Staskus on 6/9/20.
//

import UIKit
import SnapKit

final class AnswerTimerCircle: UIView {
    private let titleLabel = UILabel()
    var text: String = "" {
        didSet {
            titleLabel.text = text
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        backgroundColor = Theme.primary
        clipsToBounds = true
        layer.cornerRadius = 60
        
        addSubviews(titleLabel.style(titleLabelStyle))
    }
    
    private func setupConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(120)
            $0.width.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
    private func titleLabelStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.textColor = Theme.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
