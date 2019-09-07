//
//  User.swift
//
//  Created by sadman samee on 9/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case username
        case id
        case name
        case profileImage = "profile_image"
        case links
    }

    var username: String?
    var id: String?
    var name: String?
    var profileImage: ProfileImage?
    var links: Links?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        profileImage = try container.decodeIfPresent(ProfileImage.self, forKey: .profileImage)
        links = try container.decodeIfPresent(Links.self, forKey: .links)
    }
}
