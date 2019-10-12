//
//  UIViewController+MBProgressHud.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    func showSpinner(with title: String, and details: String) {
        performUIUpdatesOnMain {
            let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            Indicator.mode = MBProgressHUDMode.annularDeterminate
            Indicator.label.text = details
            Indicator.detailsLabel.text = "Tap to cancel"
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideSpinner))
            Indicator.addGestureRecognizer(tap)
        }
    }

    @objc func hideSpinner() {
        performUIUpdatesOnMain {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
