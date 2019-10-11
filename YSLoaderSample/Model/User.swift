//
//  User.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/11/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation

class User: Codable {
    let id: String?
    let userName: String?
    let name: String?
    let profileImage: ImageUrl?
    let links : Link?

    enum CodingKeys: String, CodingKey {
        case id
        case userName
        case name
        case profileImage = "profile_image"
        case links
    }
}
