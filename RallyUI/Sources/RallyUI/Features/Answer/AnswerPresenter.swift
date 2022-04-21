import UIKit
import RallyCore

typealias AnswerPresenter = FeaturePresenter<AnswerViewController, AnswerAdapter>

class AnswerAdapter: FeatureAdapter {
    typealias Content = Answer.Data
    typealias ViewModel = Answer.ViewModel
    
    func makeViewModel(viewState: ViewState<Answer.ViewModel.Content>) -> Answer.ViewModel {
        return Answer.ViewModel(
            state: viewState,
            title: ""
        )
    }
    
    func makeContentViewModel(content: Answer.Data) throws -> Answer.ViewModel.Content {
        let question = content.question
        
        return Answer.ViewModel.Content(
            title: "\(question.no). \(question.name)",
            imageUrl: URL(string: question.imageUrl ?? ""),
            question: question.text,
            type: makeTypeContentModel(question, selectedChoiceNo: content.selectedChoice),
            showSavedNoConnectionAlert: content.savedNoConnection,
            eventName: content.event?.name ?? ""
        )
    }
    
    private func makeTypeContentModel(_ question: RallyCore.Question, selectedChoiceNo: Int?) -> Answer.ViewModel.Content.QuestionType {
        switch question.type {
        case .choice:
            return .choice(choices: makeChoiceModels(question, selectedChoiceNo: selectedChoiceNo))
        case .decimal:
            return .decimal(value: question.state.value)
        case .number:
            return .number(value: question.state.value)
        case .text:
            return .text(value: question.state.value)
        }
    }
    
    private func makeChoiceModels(_ question: RallyCore.Question, selectedChoiceNo: Int?) -> [Answer.ViewModel.Content.QuestionType.Choice] {
        guard let answers = question.answers else { return [] }
        
        return answers.map { answer in
            var imageUrl: URL?
            var title: String?
            
            if case let .text(value) = answer.type {
                title = value
            }
            
            if case let .image(value) = answer.type {
                imageUrl = URL(string: value)
            }
            
            return Answer.ViewModel.Content.QuestionType.Choice(
                id: answer.no,
                title: title,
                imageUrl: imageUrl,
                selected: selectedChoiceNo == answer.no
            )
        }
    }
}
