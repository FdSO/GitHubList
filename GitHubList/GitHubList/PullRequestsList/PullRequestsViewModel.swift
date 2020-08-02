//
//  PullRequestsViewModel.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

import Alamofire

final class PullRequestsViewModel: NSObject {
    
    private(set) var repository: RepositoryModel
    
    private(set) var statusMessage: String = .init()
    
    var model: [PullRequestModel] {
        return repository.pullRequests ?? .init()
    }
    
    private var dataRequest: DataRequest?
    
    init(model: RepositoryModel) {
        repository = model
    }
}

extension PullRequestsViewModel {
    
    // chamada para api rest do github para função de lista de PR de um repositório
    func getPullRequests(completion: @escaping (NSError?) -> Void) {
        
        if let url = repository.url, NetworkReachabilityManager.default?.isReachable ?? false {
            dataRequest = AF.request(url.appendingPathComponent("pulls")).responseDecodable(of: [PullRequestModel].self) { (response) in
                
                switch response.result {
                case .success(let obj):
                    self.repository.pullRequests = obj
                    self.statusMessage = obj.isEmpty ? "Empyt Pulls" : .init()
                    completion(nil)

                case .failure(let err):
                    self.repository.pullRequests?.removeAll()
                    self.statusMessage = err.localizedDescription
                    completion(err as NSError)
                }
            }
        } else {
            repository.pullRequests?.removeAll()
            statusMessage = "No internet connection"
            completion(.init(domain: .init(), code: 0, userInfo: [NSLocalizedDescriptionKey: statusMessage]))
        }
    }
    
    // cancela a última requisição da api
    func cancelRequest() {
        dataRequest?.cancel()
    }
    
    func existInCoreData() -> Bool {
        guard let id = repository.id else {
            return false
        }
        
        return RepositoryCoreData.exist(id: id)
    }
    
    func saveInCoreData() -> Bool {
        
        guard let id = repository.id, let fullName = repository.fullName, let watchers = repository.watchers else {
                return false
        }
        
        return RepositoryCoreData.create(id: id, fullName: fullName, watchers: watchers)
    }
    
    func deleteFromCoreData() -> Bool {
        
        guard let id = repository.id else {
                return false
        }
        
        return RepositoryCoreData.delete(id: id)
    }
}
