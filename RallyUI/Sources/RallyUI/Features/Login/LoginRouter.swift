import UIKit
import SafariServices

class LoginRouter {
    unowned var viewController: LoginViewController!
    unowned let eventsConfigurator: EventsConfigurator
    
    private let forgotPasswordUrl = "https://racingtiming.com/4rallyeu/iframe4rallyeu.php?m=9&l=5&fm=1003&app=1&fbclid=IwAR2Sbg0b-OWayGd2vo6avfe3r7TLv1-LoJUcO9XcVubdfqDvndgJd7ZCY7Q"
    private let registrationUrl = "https://racingtiming.com/4rallyeu/iframe4rallyeu.php?m=9&l=5&fm=1002&app=1&fbclid=IwAR1cMWVSNpBvl4PnoAr3V1EvHN4iVMge9KFRElq3TRLcJWXjWkU9Ad9Pl40"

    init(eventsConfigurator: EventsConfigurator) {
        self.eventsConfigurator = eventsConfigurator
    }

    func route(to route: Login.Route) {
        switch route {
        case .loginFinished:
            let navigationController = BaseNavigationViewController(rootViewController: eventsConfigurator.createViewController())
            UIApplication.shared.keyWindow?.rootViewController = navigationController
        case .forgotPassword:
            guard let url = URL(string: forgotPasswordUrl) else { return }
            let webViewController = SFSafariViewController(url: url)
            viewController.present(webViewController, animated: true, completion: nil)
        case .register:
            guard let url = URL(string: registrationUrl) else { return }
            let webViewController = SFSafariViewController(url: url)
            viewController.present(webViewController, animated: true, completion: nil)
        }
    }
}
