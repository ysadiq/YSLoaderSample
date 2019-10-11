//
//  PinboardViewController.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import UIKit

class PinboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: PinboardViewModel = {
        return PinboardViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initViewModel()
    }

    /// Initialize devicePermission viewmodel
    func initViewModel() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            guard let self = self else { return }

            DispatchQueue.main.async {
                let offset = self.tableView.contentOffset
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                // Force layout so things are updated before resetting the contentOffset.
                self.tableView.setContentOffset(offset, animated: false)
//                self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
            }
        }

        viewModel.fetchPins()
    }
}

extension PinboardViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.pinboardTableViewCell, for: indexPath)
        guard let cellItem = cell as? PinboardTableViewCell,
            let permission = viewModel.getCellViewModel(at: indexPath) else {
                return cell
        }

        cellItem.configure(with: permission)
        // Set delegate for hyperlink in textView
        cellItem.requestTextView.delegate = self
        return cellItem
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = true
    }
}
