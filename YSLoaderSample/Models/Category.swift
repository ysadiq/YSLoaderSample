//
//  Category.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/11/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation

class Category: Codable {
    let id: Int?
    let title: String?
    let photoCount: Int?
    let links: ImageUrl?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case photoCount = "photo_count"
        case links
    }
}
