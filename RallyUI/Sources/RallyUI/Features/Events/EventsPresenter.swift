import UIKit
import RallyCore

typealias EventsPresenter = FeaturePresenter<EventsViewController, EventsAdapter>

class EventsAdapter: FeatureAdapter {
    typealias Content = Events.Data
    typealias ViewModel = Events.ViewModel

    func makeViewModel(viewState: ViewState<Events.ViewModel.Content>) -> Events.ViewModel {
        return Events.ViewModel(
            state: viewState,
            title: ""
        )
    }

    func makeContentViewModel(content: Events.Data) throws -> Events.ViewModel.Content {
        return Events.ViewModel.Content(title: ~"events_title",
                                        items: getItems(from: content),
                                        isConnected: content.connnectionStatus != .noConnection)
    }
    
    private func getItems(from content: Events.Data) -> [Events.ViewModel.ContentViewModel.Item] {
        return content.events.enumerated()
            .map { (id, event) in
                return Events.ViewModel.ContentViewModel.Item(
                    id: id + 1,
                    name: event.name,
                    route: Events.Route.event(content.user, event))
        }
    }
}
