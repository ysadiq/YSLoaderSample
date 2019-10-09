//
//  ViewController.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import UIKit
import YSLoader

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let imageURL = "https://limemicro.com/app/uploads/2018/08/Vodafone_1024x768_HeaderSafe.jpg"
        let loader: YSLoader = YSLoader()
        loader.image(with: imageURL) { (image) in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }


}

