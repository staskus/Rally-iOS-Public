import Foundation
import RallyCore

struct Events {
    struct Data: Equatable {
        var user: User
        var events: [Event]
        var connnectionStatus: ConnectionWatcherStatus
    }

    struct ViewModel: FeatureViewModel {
        let state: ViewState<Events.ViewModel.Content>
        let title: String

        struct Content: FeatureContentViewModel {
            struct Item {
                let id: Int
                let name: String
                let route: Route
            }
            
            let title: String
            let items: [Item]
            let isConnected: Bool
            
            var hasContent: Bool {
                return true
            }
        }
    }

    enum Action {
        case load
        case logout
    }

    enum Route {
        case event(User, Event)
        case logout
    }
}
