//
//  UIViewController+MBProgressHud.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import MBProgressHUD

extension PinboardViewController {
    func showSpinner(with title: String, and details: String) {
        performUIUpdatesOnMain { [weak self] in
            guard let self = self else {
                return
            }
            let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            Indicator.mode = MBProgressHUDMode.annularDeterminate
            Indicator.label.text = details
            Indicator.detailsLabel.text = "Tap to cancel"
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancelSpinner))
            Indicator.addGestureRecognizer(tap)
        }
    }

    func hideSpinner() {
        performUIUpdatesOnMain { [weak self] in
            guard let self = self else {
                return
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    @objc func cancelSpinner() {
//        viewModel.cancelFetch()
        performUIUpdatesOnMain { [weak self] in
            guard let self = self else {
                return
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
