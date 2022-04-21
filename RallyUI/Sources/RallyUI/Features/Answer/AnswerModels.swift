import Foundation
import RallyCore

struct Answer {
    struct Data: Equatable {
        let event: RallyCore.Event?
        let question: Question
        var selectedChoice: Int?
        var savedNoConnection: Bool = false
    }

    struct ViewModel: FeatureViewModel {
        let state: ViewState<Answer.ViewModel.Content>
        let title: String

        struct Content: FeatureContentViewModel {
            enum QuestionType {
                struct Choice {
                    let id: Int
                    let title: String?
                    let imageUrl: URL?
                    let selected: Bool?
                    
                    var isImage: Bool {
                        return imageUrl != nil
                    }
                }
                
                case text(value: String?)
                case number(value: String?)
                case decimal(value: String?)
                case choice(choices: [Choice])
            }
            
            let title: String
            let imageUrl: URL?
            let question: String
            let type: QuestionType
            let showSavedNoConnectionAlert: Bool
            let eventName: String
        }
    }

    enum Action {
        case load
        case submit(String?)
        case selectChoice(Int)
    }

    enum Route {
        case back
    }
}
