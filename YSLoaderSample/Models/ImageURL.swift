//
//  ImageURL.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/11/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation

class ImageURL: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let medium: String?
    let large: String?

    func imageURLString(of size: ImageSize) -> String? {
        switch size {
        case .raw:
            return raw
        case .full:
            return full
        case .regular:
            return regular
        case .small:
            return small
        case .thump:
            return thumb
        case .large:
            return large
        case .medium:
            return medium
        }
    }
}

enum ImageSize {
    case raw
    case full
    case regular
    case large
    case medium
    case small
    case thump
}
