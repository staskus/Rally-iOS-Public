import UIKit
import RallyCore
import CoreLocation

typealias QuestionsPresenter = FeaturePresenter<QuestionsViewController, QuestionsAdapter>

class QuestionsAdapter: FeatureAdapter {
    typealias Content = Questions.Data
    typealias ViewModel = Questions.ViewModel
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    func makeViewModel(viewState: ViewState<Questions.ViewModel.Content>) -> Questions.ViewModel {
        return Questions.ViewModel(
            state: viewState
        )
    }

    func makeContentViewModel(content: Questions.Data) throws -> Questions.ViewModel.Content {
        return Questions.ViewModel.Content(title: getTitle(from: content.event),
                                           subtitle: getSubtitle(from: content.event),
                                           items: getItems(from: content),
                                           empty: getEmptyViewModel(content: content),
                                           isConnected: content.connnectionStatus != .noConnection,
                                           inactiveBefore: inactiveBefore(from: content),
                                           inactiveAfter: inactiveAfter(from: content))
    }
    
    private func getItems(from content: Questions.Data) -> [Questions.ViewModel.ContentViewModel.Item] {
        return content.questions
            .sorted { $0.no < $1.no }
            .map { question in
                let state = getState(from: question, for: content.location, loadingAnswers: content.loadingAnswers)
                let details = getDetails(for: state)
                return Questions.ViewModel.ContentViewModel.Item(
                    id: question.no,
                    name: question.name,
                    state: state,
                    route: .select(question, content.event, content.user),
                    details: details
                )
        }
    }
    
    private func getState(from question: Question, for location: CLLocation?, loadingAnswers: [QuestionAnswer]) -> Questions.ViewModel.ContentViewModel.Item.State {
        if question.state.isAnswered {
            return .answered
        } else if (loadingAnswers.map { $0.questionNo }).contains(question.no) {
            return .loading
        } else if QuestionInAreaCalculator.isQuestionInArea(question, in: location) {
            return .open
        } else {
            return .closed
        }
    }
    
    private func getDetails(for state: Questions.ViewModel.ContentViewModel.Item.State) -> String {
        switch state {
        case .open:
            return ~"questions_active_details"
        case .closed:
            return ~"questions_inactive_details"
        case .answered:
            return ~"questions_done_details"
        case .loading:
            return ~"questions_saving_details"
        }
    }
    
    private func inactiveBefore(from content: Questions.Data) -> String? {
        // HERE
        guard let activatonTime = content.activationTime else {
            return nil
        }
        
        let currentTimeInterval = Date().timeIntervalSince1970
        if currentTimeInterval >= activatonTime.timeIntervalSince1970 {
            return nil
        }
        
        return String(format: ~"questions_inactive_time_alert_before_description", dateFormatter.string(from: activatonTime))
    }
    
    private func inactiveAfter(from content: Questions.Data) -> String? {
        guard let deactivationTime = content.deactivationTime else {
            return nil
        }
                
        let currentTimeInterval = Date().timeIntervalSince1970
        
        if currentTimeInterval <= deactivationTime.timeIntervalSince1970 {
            return nil
        }
        
        return String(format: ~"questions_inactive_time_alert_after_description", dateFormatter.string(from: deactivationTime))
    }
    
    private func getTitle(from event: Event) -> String {
        return event.name
    }
    
    private func getSubtitle(from event: Event) -> NSAttributedString {
        let subtitle = NSMutableAttributedString(string: ~"questions_stNr")
        subtitle.append(NSMutableAttributedString(string: " "))
        let stNr = NSMutableAttributedString(string: event.stNr.isEmpty ? "-" : event.stNr)
        stNr.addAttributes([.font: UIFont.boldSystemFont(ofSize: Theme.Font.extraSmall.pointSize)], range: NSRange(location: 0, length: stNr.length))
        subtitle.append(stNr)
        subtitle.append(NSMutableAttributedString(string: ", "))
        subtitle.append(NSMutableAttributedString(string: ~"questions_team"))
        subtitle.append(NSMutableAttributedString(string: " "))
        let team = NSMutableAttributedString(string: event.crewName.isEmpty ? "-" : event.crewName)
        team.addAttributes([.font: UIFont.boldSystemFont(ofSize: Theme.Font.extraSmall.pointSize)], range: NSRange(location: 0, length: team.length))
        subtitle.append(team)
        
        return subtitle
    }
    
    private func getEmptyViewModel(content: Questions.Data) -> EmptyViewModel? {
        // HERE
        let timeUntilEvent = content.timeUntilEvent
        guard timeUntilEvent <= 0 else {
            let event = content.event
            return EmptyViewModel(imageName: "time_off",
                                  title: ~"questions_future_event_title",
                                  details: String(format: ~"questions_future_event_time", dateFormatter.string(from: event.from)),
                                  action: nil)
        }
        
        if content.locationPermission.noLocationPermission {
            return EmptyViewModel(imageName: "location_off",
                                  title: ~"questions_no_location_access_title",
                                  details: nil,
                                  action: .init(title: ~"questions_no_location_access_button", action: {
                                    content.locationPermission.onPermission(.askForLocation)
                                  }))
        }
        
        return nil
    }
}
