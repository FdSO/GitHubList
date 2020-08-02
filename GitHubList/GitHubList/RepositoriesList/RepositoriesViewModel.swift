//
//  RepositoriesViewModel.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

import Alamofire

final class RepositoriesViewModel: NSObject {
    
    private var github: GitHubModel? {
        didSet {
            
            // agrupa os repositórios a cada página
            if let items = github?.items {
                page += 1
                model.append(contentsOf: items)
            }
        }
    }
    
    private(set) var model: [RepositoryModel] = .init()
    
    private(set) var statusMessage: String = .init()
    
    private var dataRequest: DataRequest?
    
    let perPage: Int // máximo 100
    
    private(set) var page: Int // pagina 0 e 1 são idênticas, git começa no 1
    
    // verifica se ainda exista algo a se carregar
    var hasMoreData: Bool {
        let currentGithubTotalCount = github?.totalCount ?? 0
        return page < (currentGithubTotalCount / perPage)
    }
    
    init(perPage: Int = 15, inicialPage: Int = 1) {
        self.perPage = perPage
        self.page = inicialPage
        super.init()
    }
}

extension RepositoriesViewModel {
    
    // chamada para api rest do github para função de repositórios
    func getRepositories(completion: @escaping (NSError?) -> Void) {
        
        if NetworkReachabilityManager.default?.isReachable ?? false {
            dataRequest = AF.request("https://api.github.com/search/repositories", parameters: ["q": "language:Swift", "sort": "stars", "per_page": perPage, "page": page]).responseDecodable(of: GitHubModel.self) { (response) in
                
                // erro de requições github
                if let error = try? JSONDecoder().decode(GitHubError.self, from: response.data ?? .init()) {
                    self.statusMessage = error.message
                    completion(.init(domain: .init(), code: -1, userInfo: [NSLocalizedDescriptionKey: error.message]))
                } else {
                    switch response.result {
                    case .success(let obj):

                        self.statusMessage = .init()
                        self.github = obj
                        completion(nil)

                    case .failure(let err):
                        completion(err as NSError)
                    }
                }
            }
        } else {
            completion(.init(domain: .init(), code: 0, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
        }
    }
    
    // cancela a última requisição da api
    func cancelRequest() {
        dataRequest?.cancel()
    }
    
    // utilizado para reiniciar a paginação na ação pull down na tela
    func resetPagination() {
        page = 1
        github = nil
        dataRequest = nil
        model.removeAll()
    }
    
    // verifica se estamos fora da quantidade de items na paginação
    func isLoadingIndexPath(_ index: Int) -> Bool {
        guard hasMoreData else {
            return false
        }
        return index == model.count
    }
}
