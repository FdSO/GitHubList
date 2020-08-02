//
//  RepositoriesTableViewController.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

import CoreData

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
        
        tableView.reloadData()
        
        tableView.backgroundView = nil
        
        tableView.bounces = true
        
        switch segmentedControl.selectedSegmentIndex {
        case 0 where viewModel.model.isEmpty:
            
            updateControl.beginRefreshing()
            
            repositoryRequest()
            
        case 1:
            tableView.bounces = false
            
        default:
            return
        }
    }
    
    @objc private func refreshWasTapped() {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            viewModel.resetPagination()
            
            // ação de pull down programaticamente
            segmentedControl.sendActions(for: .valueChanged)
            
        case 1:
            return
            
        default:
            return
        }
    }
    
    private lazy var fetchController: NSFetchedResultsController<RepositoryCoreData> = {
        
        let request = NSFetchRequest<RepositoryCoreData>(entityName: "RepositoryCoreData")
        
        request.sortDescriptors = [.init(key: "createAt", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate?.persistentContainer.viewContext ?? .init(concurrencyType: .mainQueueConcurrencyType), sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()
    
    private let viewModel: RepositoriesViewModel = .init()
    
    weak var coordinator: AppCoordinator?
    
    override func loadView() {
        super.loadView()
        
        initComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? fetchController.performFetch()
        
        segmentedControl.setEnabled(!(fetchController.fetchedObjects?.isEmpty ?? true), forSegmentAt: 1)
        
        segmentedControl.sendActions(for: .valueChanged)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
            
        // caso exista mais páginas na paginação, acrescenta um espaço para a célula de carregamento
        case 0:
            return viewModel.model.count + (viewModel.hasMoreData ? 1 : 0)
            
        case 1:
            return fetchController.fetchedObjects?.count ?? 0
            
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // utilizado caso a celula seja customizada
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DATA_CELL", for: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
            
        // célula para repositório online
        case 0 where indexPath.row <= viewModel.model.count:
            
            // célula para carregamento e aviso, caso seja a última da lista
            if viewModel.isLoadingIndexPath(indexPath.row) {
                
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                
                cell.selectionStyle = .none
                
                let detailLabelFont = cell.detailTextLabel?.font
                
                cell.textLabel?.text = viewModel.statusMessage
                cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = "Loading.."
                cell.detailTextLabel?.font = cell.textLabel?.font
                cell.textLabel?.font = detailLabelFont
                
                return cell
            }
            
            let cell: UITableViewCell = .init(style: .subtitle, reuseIdentifier: nil)
            
            let model = viewModel.model[indexPath.row]
           
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            cell.textLabel?.text = model.fullName
            cell.detailTextLabel?.text = model.desc
            
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
           
        case 1 where indexPath.row < fetchController.fetchedObjects?.count ?? 0:
            
            let cell: UITableViewCell = .init(style: .value1, reuseIdentifier: nil)
            
            let model = fetchController.object(at: indexPath)
            
            cell.selectionStyle = .none
            cell.textLabel?.text = "⭐️ " + (model.watchers.intValue.asAbbrevation() ?? "-")
            cell.detailTextLabel?.text = model.fullName
           
            return cell
            
        default:
            break
        }
        
        return .init()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0 where indexPath.row < viewModel.model.count:
            coordinator?.detail(model: viewModel.model[indexPath.row])
            
        default:
            return
        }
    }
    
    
    // utilizado para o carregamento na rolagem, caso necessário
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0 where viewModel.isLoadingIndexPath(indexPath.row):
            
            // cancela a requisação anterior e prepara a próxima, isso mantém a suavidade da rolagem
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.repositoryRequest), object: nil)

            perform(#selector(self.repositoryRequest), with: nil, afterDelay: 0.5)
            
        default:
            return
        }
    }
}

extension RepositoriesTableViewController {
    private func initComponents() {
        clearsSelectionOnViewWillAppear = true
        
        refreshControl = updateControl
        
        navigationItem.titleView = segmentedControl
        
        // utilizado caso a celula seja customizada
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DATA_CELL")
    }
    
    @objc private func repositoryRequest() {
        
        viewModel.getRepositories { (error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateControl.endRefreshing()
                
                self.tableView.reloadData()
                
                // exibe o erro em formato de AlertController quando a lista é vazia
                if let e = error, self.viewModel.model.isEmpty {
                    self.presentAlertController(title: e.localizedDescription, message: nil, preferredStyle: .alert) {
                        self.tableView.backgroundView = self.descLabel
                    }
                }
            }
        }
    }
}

extension RepositoriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        segmentedControl.setEnabled(!(controller.fetchedObjects?.isEmpty ?? true), forSegmentAt: 1)
    }
}
