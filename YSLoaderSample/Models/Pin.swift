//
//  PinboardModel.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import UIKit

class Pin: Decodable {

    var id: String?
    var createdAt: Date?
    var width: Int?
    var height: Int?
    var color: UIColor?
    var likes: Int?
    var isLikedByUser: Bool?

    var user: User?
    var imageUrl: ImageUrl?
    var categories: [Category]?
    var links: Link?

    static var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case likes
        case isLikedByUser = "liked_by_user"

        case user
        case imageUrls = "urls"
        case categories
        case links
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decodeIfPresent(String.self, forKey: .id)
        if let dateString = try values.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = Pin.dateFormatter.date(from: dateString)
        }
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        if let colorString = try values.decodeIfPresent(String.self, forKey: .color) {
            color = UIColor(named: colorString)
        }

        likes = try values.decodeIfPresent(Int.self, forKey: .height)
        isLikedByUser = try values.decodeIfPresent(Bool.self, forKey: .isLikedByUser)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        imageUrl = try values.decodeIfPresent(ImageUrl.self, forKey: .imageUrls)
        categories = try values.decodeIfPresent([Category].self, forKey: .categories)
        links = try values.decodeIfPresent(Link.self, forKey: .links)
    }
}

