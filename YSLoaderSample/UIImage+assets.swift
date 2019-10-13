//
//  UIImage+assets.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/13/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import UIKit

enum Asset: String, CaseIterable {
    case notFound = "notFound"
}

extension UIImage {
    convenience init?(asset image: Asset) {
        self.init(named: image.rawValue)
    }
}
