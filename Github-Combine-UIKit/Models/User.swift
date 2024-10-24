//
//  User.swift
//  Github-Combine-UIKit
//
//  Created by Francisco Rosa on 07/08/2024.
//

import Foundation

struct User: Decodable {
    let id: Double
    let login: String
    let avatarURL: String
    let followers: Int
    let publicRepos: Int
    let publicGists: Int
    let name: String?
    let company: String?
    let location: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case followers
        case name
        case company
        case location
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
    }
}
