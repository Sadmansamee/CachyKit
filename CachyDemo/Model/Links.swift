//
//  Links.swift
//
//  Created by sadman samee on 9/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Links: Codable {
    enum CodingKeys: String, CodingKey {
        case photos
        // case selfKey = "self"
    }

    var photos: String?
    // var selfValue: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photos = try container.decodeIfPresent(String.self, forKey: .photos)
        // selfValue = try container.decodeIfPresent(String.self, forKey: .selfKeyselfKeyb)
    }
}
