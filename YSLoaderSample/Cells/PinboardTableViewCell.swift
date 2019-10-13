//
//  PinboardTableViewCell.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/11/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import YSLoader
import UIKit

class PinboardTableViewCell: UITableViewCell {
    @IBOutlet var pinImageView: UIImageView!

    func configure(with pinboardCellViewModel: PinboardCellViewModel) {
        YSLoader.shared.load(with: pinboardCellViewModel.imageURL,
                             dataType: .image) {[weak self] (result: Result<UIImage, Error>) in
                                guard let self = self else {
                                    return
                                }
                                switch result{
                                case .success(let image):
                                    self.pinImageView.image = image
                                case .failure:
                                    self.pinImageView.image = UIImage(asset: .notFound)
                                }
        }
    }
}
