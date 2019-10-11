//
//  Link.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/11/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation

class Link: Codable {
    let `self`: String?
    let html: String?
    let download: String?
    let photos: String?
    let likes: String?

    enum CodingKeys: String, CodingKey {
        case `self` = "self"
        case html
        case download
        case photos
        case likes
    }
}
