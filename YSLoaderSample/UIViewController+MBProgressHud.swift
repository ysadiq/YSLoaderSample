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
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.label.text = title
        Indicator.isUserInteractionEnabled = false
        Indicator.detailsLabel.text = details
        Indicator.show(animated: true)
    }

    func hideSpinner() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
