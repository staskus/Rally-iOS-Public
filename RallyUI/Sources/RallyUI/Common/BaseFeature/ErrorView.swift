//
//  ErrorView.swift
//  RallyUI
//
//  Created by Povilas Staskus on 9/27/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit

protocol ErrorSettable {
    func configure(_ text: String)
}

class ErrorView: UIView {
    let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = Theme.backgroundColor
        isUserInteractionEnabled = false
        
        addSubviews(
            label
                .style(Style.Label.medium)
                .style { $0.textColor = Theme.primary }
                .style(Style.Label.multiline)
                .style(Style.Label.center)
        )
        
        label.snp.makeConstraints { make in
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ErrorView: ErrorSettable {
    func configure(_ text: String) {
        label.text = text
    }
}
