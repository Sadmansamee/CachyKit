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
}
