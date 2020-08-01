//
//  RepositoriesTableViewController.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

final class RepositoriesTableViewController: UITableViewController {

    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
