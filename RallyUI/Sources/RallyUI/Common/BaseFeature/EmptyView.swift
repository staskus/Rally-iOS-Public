//
//  EmptyView.swift
//  RallyUI
//
//  Created by Povilas Staskus on 9/27/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

struct EmptyViewModel {
    struct Action {
        let title: String
        let action: (() -> ())
    }
    let imageName: String
    let title: String
    let details: String?
    let action: EmptyViewModel.Action?
}

class EmptyView: UIView {
    let label = UILabel()
    let imageView = UIImageView()
    let detailsLabel = UILabel()
    let actionButton = UIButton()
    private let containerView = UIView()
    private let disposeBag = DisposeBag()
    private var action: EmptyViewModel.Action?

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    func configure(_ viewModel: EmptyViewModel) {
        label.text = viewModel.title
        imageView.image = UIImage(named: viewModel.imageName)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.primary
        
        if let details = viewModel.details {
            detailsLabel.text = details
        } else if let action = viewModel.action {
            actionButton.setTitle(action.title, for: .normal)
            actionButton.isHidden = false
            actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
            self.action = action
        }
    }
    
    private func setupView() {
        backgroundColor = Theme.backgroundColor

        addSubviews(
            containerView.addSubviews(
                imageView
                    .style(Style.Image.scaleAspectFit),
                label
                    .style(Style.Label.medium)
                    .style { $0.textColor = Theme.primary }
                    .style(Style.Label.multiline)
                    .style(Style.Label.center)
            ),
            detailsLabel.style(Style.Label.small)
                .style { $0.textColor = Theme.primary }
                .style(Style.Label.multiline)
                .style(Style.Label.center),
            actionButton
                .style(Style.Button.main)
                .style { $0.isHidden = true }
        )
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalTo(snp.width).multipliedBy(0.65)
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom)
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(snp.width).multipliedBy(0.65)
        }
        
        actionButton.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(46)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    @objc private func actionButtonTapped() {
        action?.action()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
