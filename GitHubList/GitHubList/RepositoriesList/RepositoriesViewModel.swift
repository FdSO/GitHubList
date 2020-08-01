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
    
    private var github: GitHubModel?
    
    var model: [RepositoryModel] {
        return github?.items ?? .init()
    }
    
    private var dataRequest: DataRequest?
    
    private let perPage: Int = 15
    
    private var page: Int = 0
}

extension RepositoriesViewModel {
    func getRepositories(completion: @escaping (NSError?) -> Void) {
        
        if NetworkReachabilityManager.default?.isReachable ?? false {
            dataRequest = AF.request("https://api.github.com/search/repositories", parameters: ["q": "language:Swift", "sort": "stars", "per_page": perPage, "page": page]).responseDecodable(of: GitHubModel.self) { (response) in
                
                switch response.result {
                case .success(let obj):
                    self.github = obj
                    completion(nil)

                case .failure(let err):
                    completion(err as NSError)
                }
            }
        } else {
            completion(.init(domain: .init(), code: 0, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
        }
    }
    
    func cancelRequest() {
        dataRequest?.cancel()
    }
}
