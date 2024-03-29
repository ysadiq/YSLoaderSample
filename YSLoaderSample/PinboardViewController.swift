//
//  PinboardViewController.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import UIKit
import YSLoader

class PinboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: PinboardViewModel = PinboardViewModel(YSLoader(), pinSize: .thump)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        initViewModel()
    }

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

        viewModel.delegate = self
        viewModel.fetchPins()
    }
}

// MARK: - UITableViewDataSource
extension PinboardViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell index \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.pinboardTableViewCell,
                                                 for: indexPath)
        guard let cellItem = cell as? PinboardTableViewCell else {
            return cell
        }

        if isLoadingCell(for: indexPath) {
            viewModel.fetchPinImage(forPinAt: indexPath)
        } else {
            guard let cellViewModel = viewModel.getCellViewModel(at: indexPath) else {
                return cell
            }
            cellItem.configure(with: cellViewModel)
        }
        return cellItem
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension PinboardViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetchRowsAt \(indexPaths)")
        indexPaths.forEach { indexPath in
            viewModel.fetchPinImage(forPinAt: indexPath)
        }
    }
}

extension PinboardViewController: PinboardViewModelDelegate {
    func onFetchCompleted(forItemIn indexPath: IndexPath) {
        if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    func onFetchCompleted() {
        performUIUpdatesOnMain { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

private extension PinboardViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if viewModel.getCellViewModel(at: indexPath)?.image == nil {
            return true
        }
        return false
    }
}
