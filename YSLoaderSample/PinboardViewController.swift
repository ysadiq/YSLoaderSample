//
//  PinboardViewController.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import UIKit
import MBProgressHUD

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

        viewModel.updateLoadingStatus = { [weak self] () in
            performUIUpdatesOnMain {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.showSpinner()
                } else {
                    self?.hideSpinner()
                }
            }
        }

        viewModel.reloadTableViewClosure = { [weak self] () in
            guard let self = self else { return }

            DispatchQueue.main.async {
                let offset = self.tableView.contentOffset
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                // Force layout so things are updated before resetting the contentOffset.
                self.tableView.setContentOffset(offset, animated: false)
            }
        }
        viewModel.fetchPins(with: .regular)
    }

    private func showSpinner() {
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.label.text = "Loading"
        Indicator.isUserInteractionEnabled = false
        Indicator.detailsLabel.text = viewModel.loadingText
        Indicator.show(animated: true)
    }

    private func hideSpinner() {
        MBProgressHUD.hide(for: self.view, animated: true)
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
            let cellViewModel = viewModel.getCellViewModel(at: indexPath) else {
                return cell
        }

        cellItem.configure(with: cellViewModel)
        return cellItem
    }
}
