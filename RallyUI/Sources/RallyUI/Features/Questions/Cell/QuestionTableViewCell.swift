//
//  QuestionTableViewCell.swift
//  
//
//  Created by Povilas Staskus on 10/20/19.
//

import UIKit
import SnapKit

final class QuestionTableViewCell: UITableViewCell, ReusableView, ConfigurableCell {
    typealias ViewModel = Questions.ViewModel.ContentViewModel.Item
    
    private let id = UILabel()
    private let title = UILabel()
    private let details = UILabel()
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
            id,
            textContainer.addSubviews(
                title,
                details
            ),
            icon
        )
    }
    
    private func setupConstraints() {
        id.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        textContainer.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(id.snp.right).offset(14)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(textContainer.snp.top)
            make.left.equalTo(textContainer.snp.left)
            make.right.equalTo(textContainer.snp.right)
            make.bottom.equalTo(details.snp.top).offset(-4)
        }
        
        details.snp.makeConstraints { make in
            make.bottom.equalTo(textContainer.snp.bottom)
            make.left.equalTo(textContainer.snp.left)
            make.right.equalTo(textContainer.snp.right)
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.left.greaterThanOrEqualTo(textContainer.snp.right).offset(12)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }
    }
    
    func configure(for viewModel: Questions.ViewModel.ContentViewModel.Item) {
        title.text = viewModel.name
        details.text = viewModel.details
        id.text = "\(viewModel.id)"
        
        configureId(for: viewModel.state)
        configureTitle(for: viewModel.state)
        configureDetails(for: viewModel.state)
        configureIcon(for: viewModel.state)
    }
}

extension QuestionTableViewCell {
    private func configureId(for state: Questions.ViewModel.ContentViewModel.Item.State) {
        id.font = Theme.Font.small
        configureLabel(id, for: state)

    }
    
    private func configureTitle(for state: Questions.ViewModel.ContentViewModel.Item.State) {
        title.font = UIFont.systemFont(ofSize: Theme.Font.small.pointSize, weight: .bold)
        configureLabel(title, for: state)
    }
    
    private func configureDetails(for state: Questions.ViewModel.ContentViewModel.Item.State) {
        details.font = Theme.Font.extraSmall
        configureLabel(details, for: state)
    }
    
    private func configureIcon(for state: Questions.ViewModel.ContentViewModel.Item.State) {
        switch state {
        case .open:
            icon.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = Theme.primary
        case .loading:
            icon.image = UIImage(named: "loading")?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = Theme.primary.withAlphaComponent(0.25)
        case .closed:
            icon.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = Theme.primary.withAlphaComponent(0.25)
        case .answered:
            icon.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = Theme.secondary
        }
    }
    
    private func configureLabel(_ label: UILabel, for state: Questions.ViewModel.ContentViewModel.Item.State) {
         switch state {
         case .open:
             label.textColor = Theme.primary
             label.alpha = 1.0
         case .loading, .closed:
             label.textColor = Theme.primary
             label.alpha = 0.25
         case .answered:
             label.textColor = Theme.secondary
             label.alpha = 1.0
         }
     }
}
