//
//  Board.swift
//
//  Created by sadman samee on 9/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Board: Codable {
    enum CodingKeys: String, CodingKey {
        case urls
        case width
        case likedByUser = "liked_by_user"
        case height
        case id
        case links
        case createdAt = "created_at"
        case likes
        case color
        case user
        case categories
    }

    var urls: Urls?
    var width: Int?
    var likedByUser: Bool?
    var height: Int?
    var id: String?
    var links: Links?
    var createdAt: String?
    var likes: Int?
    var color: String?
    var user: User?
    var categories: [Categories]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        urls = try container.decodeIfPresent(Urls.self, forKey: .urls)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        likedByUser = try container.decodeIfPresent(Bool.self, forKey: .likedByUser)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        links = try container.decodeIfPresent(Links.self, forKey: .links)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        likes = try container.decodeIfPresent(Int.self, forKey: .likes)
        color = try container.decodeIfPresent(String.self, forKey: .color)
        user = try container.decodeIfPresent(User.self, forKey: .user)
        categories = try container.decodeIfPresent([Categories].self, forKey: .categories)
    }
}
