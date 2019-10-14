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
        return PinboardViewModel(pinSize: .regular)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.prefetchDataSource = self
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

//        viewModel.reloadTableViewClosure = { [weak self] () in
//            guard let self = self else { return }
//
//            performUIUpdatesOnMain {
//                let offset = self.tableView.contentOffset
//                self.tableView.reloadData()
//                self.tableView.layoutIfNeeded()
//                // Force layout so things are updated before resetting the contentOffset.
//                self.tableView.setContentOffset(offset, animated: false)
//            }
//        }
        viewModel.delegate = self
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

//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        print("cancelPrefetchingForRowsAt \(indexPaths)")
//        indexPaths.forEach { indexPath in
//            viewModel.cancelImageFetch(forPinAt: indexPath.row)
//        }
//    }
}

extension PinboardViewController: PinboardViewModelDelegate {
    func onFetchCompleted(forItemIn indexPath: IndexPath) {
        if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    func onFetchCompleted() {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }

    func onFetchFailed(with reason: String) {
//        indicatorView.stopAnimating()
//
//        let title = "Warning".localizedString
//        let action = UIAlertAction(title: "OK".localizedString, style: .default)
//        displayAlert(with: title , message: reason, actions: [action])
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
