//
//  PinCellViewModel.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/14/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import UIKit

struct PinboardCellViewModel {
    let imageURL: String
    var image: UIImage?

    init(imageURL: String, image: UIImage? = nil) {
        self.imageURL = imageURL
        self.image = image
    }
}

