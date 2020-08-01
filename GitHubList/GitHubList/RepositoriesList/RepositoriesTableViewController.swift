//
//  RepositoriesTableViewController.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

import AlamofireImage

final class RepositoriesTableViewController: UITableViewController {

    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["GitHub","CoreData"])
        
        sc.addTarget(self, action: #selector(segmentedWasTapped), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    private lazy var updateControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        
        rc.addTarget(self, action: #selector(refreshWasTapped), for: .valueChanged)
        rc.attributedTitle = .init(string: "Updating")

        return rc
    }()
    
    private lazy var descLabel: UILabel = {
        let l = UILabel()
        
        l.textAlignment = .center
        l.text = "Empty Data"

        return l
    }()
    
    @objc private func segmentedWasTapped() {
        
        viewModel.cancelRequest()
        
        tableView.backgroundView = nil
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            updateControl.beginRefreshing()
            
            viewModel.getRepositories { (error) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.updateControl.endRefreshing()
                    
                    self.tableView.reloadData()
                    
                    if let e = error {
                        self.presentAlertController(title: e.localizedDescription, message: nil, preferredStyle: .alert) {
                            self.tableView.backgroundView = self.descLabel
                        }
                    }
                }
            }
            
        case 1:
            return
            
        default:
            return
        }
    }
    
    @objc private func refreshWasTapped() {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentedControl.sendActions(for: .valueChanged)
            
        case 1:
            return
            
        default:
            return
        }
    }
    
    private let viewModel: RepositoriesViewModel = .init()
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        segmentedControl.setEnabled(false, forSegmentAt: 1)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // utilizado caso a celula seja customizada
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DATA_CELL", for: indexPath)
        
        let cell: UITableViewCell = .init(style: .subtitle, reuseIdentifier: nil)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0 where indexPath.row < viewModel.model.count:
            let model = viewModel.model[indexPath.row]
           
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            cell.textLabel?.text = model.fullName
            cell.detailTextLabel?.text = model.desc
            
            cell.imageView?.layer.borderColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            cell.imageView?.layer.borderWidth = 1.0
            cell.imageView?.image = .init()
            
            cell.imageView?.af.cancelImageRequest()
            cell.imageView?.af.setImage(withURL: model.avatarURL, filter: AspectScaledToFitSizeFilter(size: .init(width: 50, height: 50)), imageTransition: .flipFromLeft(0.5), runImageTransitionIfCached: false, completion: { (_) in
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            })
           
        case 1:
            break
           
        default:
            break
        }
        
        return cell
    }
}

extension RepositoriesTableViewController {
    private func initComponents() {
        clearsSelectionOnViewWillAppear = true
        
        refreshControl = updateControl
        
        navigationItem.titleView = segmentedControl
        
        segmentedControl.sendActions(for: .valueChanged)
        
        // utilizado caso a celula seja customizada
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DATA_CELL")
    }
}
