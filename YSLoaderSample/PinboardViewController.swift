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
        tableView.prefetchDataSource = self
//        tableView.dataSource = self
        // Do any additional setup after loading the view.
        initViewModel()
    }

    /// Initialize devicePermission viewmodel
    func initViewModel() {

        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            if self.viewModel.isLoading {
                self.showSpinner(with: "Loading", and: self.viewModel.loadingText)
            } else {
                self.hideSpinner()
            }
        }

        viewModel.reloadTableViewClosure = { [weak self] () in
            guard let self = self else { return }

            performUIUpdatesOnMain {
                if self.viewModel.reloadForRow == nil {
                    let offset = self.tableView.contentOffset
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    // Force layout so things are updated before resetting the contentOffset.
                    self.tableView.setContentOffset(offset, animated: false)
                } else if let row = self.viewModel.reloadForRow {
                    let indexPath = IndexPath(row: row, section: 0)
                    if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                        self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
                    }
                }
            }
        }

        viewModel.fetchPins()
    }
}

// MARK: - UITableViewDataSource
extension PinboardViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.pinboardTableViewCell, for: indexPath)
        guard let cellItem = cell as? PinboardTableViewCell else {
            return cell
        }

        if let cellViewModel = viewModel.getCellViewModel(at: indexPath.row) {
            cellItem.configure(with: cellViewModel)
        }

        return cellItem
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension PinboardViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetchRowsAt \(indexPaths)")
        indexPaths.forEach {
            viewModel.getCellViewModel(at: $0.row)
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancelPrefetchingForRowsAt \(indexPaths)")
        indexPaths.forEach {
            viewModel.cancelImageFetching(forPinAt: $0.row)
        }
    }
}
