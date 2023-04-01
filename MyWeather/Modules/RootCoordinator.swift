import UIKit

final class RootCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let searchVC = SearchViewController.loadFromNib()
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: false)
    }
}
