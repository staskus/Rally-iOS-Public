//
//  NoInternetView.swift
//  
//
//  Created by Povilas Staskus on 11/23/19.
//

import UIKit

final class NoInternetView: UIView {
    private let imageView = UIImageView()
    private let containerView = UIView()
    private let textContainer = UIView()
    private let title = UILabel()
    private let details = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        backgroundColor = Theme.primaryLight
        clipsToBounds = true
        
        addSubviews(
            containerView.addSubviews(
                imageView.style(Style.Image.scaleAspectFit).style(imageStyle),
                textContainer.addSubviews(
                    title.style(titleStyle),
                    details.style(detailsStyle)
                )
            )
        )
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(containerView.snp.centerY)
            make.left.equalTo(containerView.snp.left)
        }
        
        textContainer.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(8)
            make.top.equalTo(containerView.snp.top)
            make.bottom.equalTo(containerView.snp.bottom)
            make.right.equalTo(containerView.snp.right)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(textContainer.snp.top)
            make.left.equalTo(textContainer.snp.left)
            make.right.equalTo(textContainer.snp.right)
        }
        
        details.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.left.equalTo(textContainer.snp.left)
            make.right.equalTo(textContainer.snp.right)
            make.bottom.equalTo(textContainer.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoInternetView {
    private func titleStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: Theme.Font.small.pointSize, weight: .bold)
        label.textAlignment = .left
        label.text = ~"questions_no_internet_title"
        label.textColor = .white
    }
    
    private func detailsStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: Theme.Font.extraSmall.pointSize)
        label.textAlignment = .left
        label.text = ~"questions_no_internet_description"
        label.textColor = .white
    }
    
    private func imageStyle(_ imageView: UIImageView) {
        imageView.image = UIImage(named: "loading")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
    }
}
