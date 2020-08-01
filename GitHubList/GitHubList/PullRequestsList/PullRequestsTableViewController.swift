//
//  PullRequestsTableViewController.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

import AlamofireImage

final class PullRequestsTableViewController: UITableViewController {

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
    
    @objc private func refreshWasTapped() {
        
        tableView.backgroundView = nil
        
        updateControl.beginRefreshing()
        
        pullsRequest()
    }
    
    private let viewModel: PullRequestsViewModel
    
    init(model: RepositoryModel) {
        
        viewModel = .init(model: model)
        
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponents()
        
        updateControl.sendActions(for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.cancelRequest()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.model.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        guard indexPath.section < viewModel.model.count else {
            return .init()
        }
        
        let model = viewModel.model[indexPath.section]
        
        cell.accessoryType = model.label == nil ? .checkmark : .detailButton
        cell.selectionStyle = .none
        
        cell.textLabel?.text = model.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = model.userName
        
        cell.imageView?.layer.borderColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        cell.imageView?.layer.borderWidth = 1.0
        cell.imageView?.image = .init()
        
        cell.imageView?.af.cancelImageRequest()
        
        if let url = model.avatarURL {
            cell.imageView?.af.setImage(withURL: url, filter: AspectScaledToFitSizeFilter(size: .init(width: 50, height: 50)), imageTransition: .flipFromLeft(0.5), runImageTransitionIfCached: false, completion: { (_) in
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let id = viewModel.model[section].id else {
            return "-"
        }
        
        return "#\(id)"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.model[section].updateAt?.asDate(dateFormat: GitHubModel.dateFormat, dateStyle: .full, timeStyle: .short) ?? "-"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        guard indexPath.section < viewModel.model.count else {
            return
        }
        
        presentAlertController(title: (viewModel.model[indexPath.section].label?.name ?? "Unknown").uppercased(), message: "Status", preferredStyle: .actionSheet)
    }
}

extension PullRequestsTableViewController {
    private func initComponents() {
        refreshControl = updateControl
    }
    
    private func pullsRequest() {
        
        viewModel.getPullRequests { (error) in
            
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
    }
}
