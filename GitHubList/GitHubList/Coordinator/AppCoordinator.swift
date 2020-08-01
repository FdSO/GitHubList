//
//  AppCoordinator.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = .init()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        home()
    }
    
    func home() {
        var viewController = RepositoriesTableViewController()
        
        if #available(iOS 13.0, *) {
            viewController = RepositoriesTableViewController(style: .insetGrouped)
        }
        
        viewController.coordinator = self
        
        viewController.navigationItem.backBarButtonItem = .init()
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func detail(model: RepositoryModel) {
        let viewController = PullRequestsTableViewController(model: model)
        
        viewController.navigationItem.title = model.fullName
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
