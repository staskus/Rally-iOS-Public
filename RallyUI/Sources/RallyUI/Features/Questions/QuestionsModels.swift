import Foundation
import RallyCore
import CoreLocation

struct Questions {
    struct Data: Equatable {
        struct LocationPermission: Equatable {
            static func == (lhs: Questions.Data.LocationPermission, rhs: Questions.Data.LocationPermission) -> Bool {
                return lhs.noLocationPermission == rhs.noLocationPermission
            }
            
            let noLocationPermission: Bool
            let onPermission: (Action) -> ()
        }
        
        let user: User
        var questions: [RallyCore.Question]
        var activationTime: Date?
        var deactivationTime: Date?
        let event: Event
        let timeUntilEvent: TimeInterval
        var locationPermission: LocationPermission
        var location: CLLocation?
        var connnectionStatus: ConnectionWatcherStatus
        var loadingAnswers: [QuestionAnswer]
    }

    struct ViewModel: FeatureViewModel {
        let state: ViewState<Questions.ViewModel.Content>

        struct Content: FeatureContentViewModel {
            struct Item {
                enum State { case open, closed, answered, loading }
                
                let id: Int
                let name: String
                let state: State
                let route: Route
                let details: String
            }
            
            let title: String
            let subtitle: NSAttributedString
            let items: [Item]
            let empty: EmptyViewModel?
            let isConnected: Bool
            let inactiveBefore: String?
            let inactiveAfter: String?
            
            var hasContent: Bool {
                return empty == nil
            }
        }
    }

    enum Action {
        case load
        case logout
        case askForLocation
    }

    enum Route {
        case select(RallyCore.Question, RallyCore.Event, RallyCore.User)
        case logout
        case settings
    }
}
