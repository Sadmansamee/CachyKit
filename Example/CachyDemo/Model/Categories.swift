//
//  Categories.swift
//
//  Created by sadman samee on 9/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Categories: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case photoCount = "photo_count"
        case links
    }

    var title: String?
    var id: Int?
    var photoCount: Int?
    var links: Links?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        photoCount = try container.decodeIfPresent(Int.self, forKey: .photoCount)
        links = try container.decodeIfPresent(Links.self, forKey: .links)
    }
}
