//
//  TeamView.swift
//  
//
//  Created by Povilas Staskus on 11/24/19.
//

import UIKit

final class TeamView: UIView {
    let title = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        backgroundColor = Theme.backgroundColor
        clipsToBounds = true
        
        addSubviews(
            title.style(titleStyle)
        )
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-4)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TeamView {
    private func titleStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: Theme.Font.extraSmall.pointSize, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
    }
}
