//
//  PullRequestsTableViewController.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

import AlamofireImage

import PureLayout

final class PullRequestsTableViewController: UITableViewController {

    private lazy var updateControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        
        rc.addTarget(self, action: #selector(refreshWasTapped), for: .valueChanged)
        rc.attributedTitle = .init(string: "Updating")

        return rc
    }()
    
    private lazy var countLabel: UILabel = {
        let l = UILabel()
        
        l.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        l.textAlignment = .center
        l.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        l.layer.cornerRadius = 5
        l.layer.masksToBounds = true
        l.text = .init(format: "Open %d PR", viewModel.model.count)
        
        return l
    }()
    
    private lazy var tableHeaderView: PullRequestDetailView = {
        let detailView = PullRequestDetailView()
        
        detailView.descriptionLabel.text = viewModel.repository.desc
        detailView.updateAtLabel.text = viewModel.repository.updateAt?.asDate(dateFormat: GitHubModel.dateFormat, dateStyle: .full, timeStyle: .short) ?? "-"
        detailView.licenseLabel.text = viewModel.repository.licenseName
        detailView.watcherLabel.text = "⭐️ " + (viewModel.repository.watchers?.asAbbrevation() ?? "-")
        
        return detailView
    }()
    
    private lazy var tableFooterView: UIView = {
        let v = UIView()
        
        v.backgroundColor = .clear
        
        return v
    }()
    
    @objc private func refreshWasTapped() {
        
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
    
    override func loadView() {
        super.loadView()
        
        initComponents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateControl.sendActions(for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.cancelRequest()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.model.isEmpty && !updateControl.isRefreshing {
            return 1
        }
        
        return viewModel.model.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.model.isEmpty {
            let cell = UITableViewCell()
            
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
            cell.textLabel?.text = viewModel.statusMessage
            cell.textLabel?.textAlignment = .center
            
            return cell
        }
        
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
        
        guard section < viewModel.model.count else {
            return nil
        }
        
        guard let id = viewModel.model[section].id else {
            return "-"
        }
        
        return "#\(id)"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        guard section < viewModel.model.count else {
            return nil
        }
        
        guard let date = viewModel.model[section].updateAt?.asDate(dateFormat: GitHubModel.dateFormat, dateStyle: .full, timeStyle: .short) else {
            return "-"
        }
        
        return date
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
        
        tableView.tableHeaderView = tableHeaderView
        
        tableHeaderView.frame.size = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        tableFooterView.frame.size.height = 100
        tableFooterView.addSubview(countLabel)

        countLabel.autoCenterInSuperview()
        countLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 100)
        countLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 100)
        countLabel.autoSetDimension(.height, toSize: 35)

        tableView.tableFooterView = tableFooterView
    }
    
    private func pullsRequest() {
        
        updateControl.beginRefreshing()
        
        viewModel.getPullRequests { (error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateControl.endRefreshing()
                
                self.tableView.reloadData()
                
                self.countLabel.text = .init(format: "Open %d PR", self.viewModel.model.count)
            }
        }
    }
}
