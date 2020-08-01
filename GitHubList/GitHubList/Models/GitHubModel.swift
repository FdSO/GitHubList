//
//  GitHubModel.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

struct PullRequestModel: Decodable {
    
    struct UserModel: Decodable {
        let name: String?
        let avatarURL: URL?

        private enum CodingKeys: String, CodingKey {
            case name = "login"
            case avatarURL = "avatar_url"
        }
    }
    
    struct LabelModel: Decodable {
        let name: String?
        let color: String?
    }

    private let user: UserModel?
    
    var userName: String? {
        return user?.name
    }
    
    var avatarURL: URL? {
        return user?.avatarURL
    }
    
    private let labels: [LabelModel]?
    
    var label: LabelModel? {
        return labels?.first
    }
    
    let id: Int?
    let title: String?
    let updateAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "number"
        case title
        case user
        case labels
        case updateAt = "updated_at"
    }
}

struct RepositoryModel: Decodable {
    struct OwnerModel: Decodable {
        let userName: String?
        let avatarURL: URL?

        private enum CodingKeys: String, CodingKey {
            case userName = "login"
            case avatarURL = "avatar_url"
        }
    }

    struct LicenseModel: Decodable {
        let name: String?
    }

    private let owner: OwnerModel?

    var userName: String? {
        return owner?.userName
    }

    var avatarURL: URL? {
        return owner?.avatarURL
    }

    private let license: LicenseModel?

    var licenseName: String? {
        return license?.name
    }

    let id: Int64?
    let fullName: String?
    let desc: String?
    let url: URL?
    let watchers: Int?
    let language: String?
    let updateAt: String?

    var pullRequests: [PullRequestModel]?

    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case desc = "description"
        case owner
        case url
        case watchers
        case language
        case license
        case updateAt = "updated_at"
    }
}

struct GitHubModel: Decodable {
    let totalCount: Int?
    let items: [RepositoryModel]?
    
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
