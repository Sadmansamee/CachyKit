//
//  ProfileImage.swift
//
//  Created by sadman samee on 9/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ProfileImage: Codable {
    enum CodingKeys: String, CodingKey {
        case medium
        case large
        case small
    }

    var medium: String?
    var large: String?
    var small: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        medium = try container.decodeIfPresent(String.self, forKey: .medium)
        large = try container.decodeIfPresent(String.self, forKey: .large)
        small = try container.decodeIfPresent(String.self, forKey: .small)
    }
}
