//
//  EventsTableViewCell.swift
//  
//
//  Created by Povilas Staskus on 6/29/20.
//

import UIKit
import SnapKit

final class EventsTableViewCell: UITableViewCell, ReusableView, ConfigurableCell {
    typealias ViewModel = Events.ViewModel.ContentViewModel.Item
    
    private let id = UILabel()
    private let title = UILabel()
    private let icon = UIImageView()
    private let textContainer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        contentView.addSubviews(
            id.style(configureId),
            textContainer.addSubviews(
                title.style(configureLabel)
            ),
            icon.style(configureIcon)
        )
    }
    
    private func setupConstraints() {
        id.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(contentView.snp.top).offset(12)
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(id.snp.right).offset(14)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-12)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(textContainer.snp.top)
            make.left.equalTo(textContainer.snp.left)
            make.right.equalTo(textContainer.snp.right)
            make.bottom.equalTo(textContainer.snp.bottom)
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.left.greaterThanOrEqualTo(textContainer.snp.right).offset(12)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }
        
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68).isActive = true
        id.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configure(for viewModel: Events.ViewModel.ContentViewModel.Item) {
        title.text = viewModel.name
        id.text = "\(viewModel.id)"
    }
}

extension EventsTableViewCell {
    private func configureId(id: UILabel) {
        id.font = Theme.Font.small
    }
    
    private func configureIcon(_ icon: UIImageView) {
        icon.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Theme.primary
    }
    
    private func configureLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: Theme.Font.small.pointSize, weight: .bold)
        label.textColor = Theme.primary
        label.alpha = 1.0
        label.numberOfLines = 0
    }
}
