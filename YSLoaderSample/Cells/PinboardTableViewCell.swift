//
//  PinboardTableViewCell.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/11/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import UIKit

class PinboardTableViewCell: UITableViewCell {
    @IBOutlet var pinImageView: UIImageView!

    func configure(with pinboardCellViewModel: PinboardCellViewModel) {
        performUIUpdatesOnMain { [weak self] in
            self?.pinImageView.image = pinboardCellViewModel.image
        }
    }
}
