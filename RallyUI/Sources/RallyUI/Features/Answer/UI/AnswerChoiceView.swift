//
//  AnswerChoiceView.swift
//  
//
//  Created by Povilas Staskus on 10/22/19.
//

import UIKit
import SnapKit
import Kingfisher

final class AnswerChoiceView: UIView, ConfigurableCell {
    typealias ViewModel = Answer.ViewModel.ContentViewModel.QuestionType.Choice
    
    private let id = UILabel()
    private let stackView = UIStackView()
    private let textChoice = UILabel()
    private let selectionIcon = UIImageView()
    private let imageChoice = UIImageView()
    private let separator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews(
            id.style(idStyle),
            selectionIcon,
            stackView.style(stackViewStyle),
            separator.style(separatorStyle)
        )
    }
    
    private func setupConstraints() {
        id.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(snp.leading).offset(4)
            make.width.equalTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(id.snp.trailing).offset(36)
            make.top.equalTo(snp.top).offset(Theme.Padding.leading)
            make.bottom.equalTo(snp.bottom).offset(Theme.Padding.trailing)
        }
        
        selectionIcon.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.leading.equalTo(stackView.snp.trailing).offset(36)
            make.trailing.equalTo(snp.trailing).offset(Theme.Padding.trailing)
        }
        
        separator.snp.makeConstraints { make in
            make.bottom.equalTo(snp.bottom)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing)
            make.height.equalTo(1)
        }
    }
    
    func configure(for viewModel: Answer.ViewModel.ContentViewModel.QuestionType.Choice) {
        id.text = "\(viewModel.id)"
        configureChoice(for: viewModel)
        configureSelection(for: viewModel)
    }
    
    private func configureChoice(for viewModel: Answer.ViewModel.ContentViewModel.QuestionType.Choice) {
        if let imageUrl = viewModel.imageUrl {
            configureImageChoice(for: imageUrl)
        } else {
            textChoice.text = viewModel.title
            stackView.addArrangedSubview(textChoice.style(textChoiceStyle))
        }
    }
    
    private func configureSelection(for viewModel: Answer.ViewModel.ContentViewModel.QuestionType.Choice) {
        selectionIcon.image = (viewModel.selected ?? false) ?
            UIImage(named: "radio_checked")?.withRenderingMode(.alwaysTemplate) :
            UIImage(named: "radio_unchecked")?.withRenderingMode(.alwaysTemplate)
        selectionIcon.tintColor = Theme.secondary
    }
    
    private func configureImageChoice(for imageUrl: URL) {
        imageChoice.kf.setImage(with: imageUrl, completionHandler: { _ in
            guard let image = self.imageChoice.image else { return }
            
            self.stackView.addArrangedSubview(self.imageChoice.style(Style.Image.scaleAspectFit))
            self.imageChoice.snp.makeConstraints { make in
                let aspectRatio = image.size.width / image.size.height
                make.height.equalTo(self.imageChoice.snp.width).dividedBy(aspectRatio)
            }
        })
    }
}

extension AnswerChoiceView {
    private func idStyle(_ label: UILabel) {
        label.font = Theme.Font.small
        label.textColor = Theme.primary
        label.numberOfLines = 1
    }
    
    private func textChoiceStyle(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: Theme.Font.small.pointSize, weight: .bold)
        label.textColor = Theme.primary
        label.numberOfLines = 0
    }
    
    private func stackViewStyle(_ stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.alignment = .leading
    }
    
    private func separatorStyle(_ view: UIView) {
        view.backgroundColor = Theme.separatorColor
    }
}
