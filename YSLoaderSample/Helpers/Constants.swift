//
//  Constants.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/11/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation

// MARK: - URLs
struct APIEndpoint {
    // MARK: - Content
    struct Content {
        static let pinsShortList: String = "http://pastebin.com/raw/wgkJgazE"
        static let pinsWithError: String = "https://pastebin.com/raw/gJv1z6Cb"
        static let pinsLongList: String = "https://pastebin.com/raw/tVMXTjpB"
    }
}

// MARK: - TableView
struct TableView {
    // MARK: - Cell Identifiers
    struct CellIdentifiers {
        static let pinboardTableViewCell: String = "PinboardTableViewCell"
    }
}
