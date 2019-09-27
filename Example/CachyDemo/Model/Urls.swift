//
//  Urls.swift
//
//  Created by sadman samee on 9/5/19
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Urls: Codable {
    enum CodingKeys: String, CodingKey {
        case small
        case regular
        case raw
        case full
        case thumb
    }

    var small: String?
    var regular: String?
    var raw: String?
    var full: String?
    var thumb: String?
}
