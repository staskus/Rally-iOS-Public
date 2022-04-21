//
//  AnswerChoicesView.swift
//  
//
//  Created by Povilas Staskus on 10/22/19.
//

import UIKit

protocol AnswerChoicesViewDelegate: class {
    func answerChoicesView(_ view: AnswerChoicesView, didSelectChoiceAtIndex index: Int)
}

final class  AnswerChoicesView: UIStackView {
    var choices: [Answer.ViewModel.ContentViewModel.QuestionType.Choice] = [] {
        didSet {
            clean()
            load(choices)
        }
    }
    
    weak var delegate: AnswerChoicesViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        alignment = .fill
    }
    
    private func load(_ choices: [Answer.ViewModel.ContentViewModel.QuestionType.Choice]) {
        for (index, choice) in choices.enumerated() {
            let choiceView = AnswerChoiceView()
            choiceView.configure(for: choice)
            choiceView.tag = index
            addArrangedSubview(choiceView)
            choiceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectChoiceView)))
        }
    }
    
    private func clean() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    @objc
    private func didSelectChoiceView(_ object: UIGestureRecognizer) {
        delegate?.answerChoicesView(self, didSelectChoiceAtIndex: object.view?.tag ?? 0)
    }
}

