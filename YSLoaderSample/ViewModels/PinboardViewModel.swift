//
//  PinboardViewModel.swift
//  YSLoaderSample
//
//  Created by Yahya Saddiq on 10/9/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//
import Foundation
import YSLoader

class PinboardViewModel: NSObject {
    var loader: YSLoaderProtocol
    var loadingText: String = "fetching details"
    var delegate: PinboardViewModelDelegate?

    private var cellViewModels: [PinboardCellViewModel] = [PinboardCellViewModel]()
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingStatus: (()->())?
    let pinSize: PinSize

    init(_ loader: YSLoaderProtocol = YSLoader(), pinSize: PinSize = .regular) {
        self.loader = loader
        self.pinSize = pinSize
    }

    convenience init(pinSize: PinSize) {
        self.init(YSLoader(), pinSize: pinSize)
    }

    func fetchPins() {
        loadingText = "Fetching Data"
        isLoading = true
        loader.load(with: APIEndpoint.Content.pinsLongList,
                    dataType: .json) { [weak self] (result: Swift.Result<Data, Error>) in
                        guard let self = self else {
                            return
                        }
                        self.isLoading = false
                        switch result {
                        case .success(let json):
                            do {
                                let pins: [Pin] = try JSONDecoder().decode([Pin].self, from: json)
                                self.processFetchedPins(pins)
                            } catch {}
                        case .failure(let error):
                            print(error)
                        }
        }
    }

    func cancelImageFetch(forPinAt index: Int) {
        let url = cellViewModels[index].imageURL
        loader.cancelRequest(of: url)
    }

    private func processFetchedPins(_ pins: [Pin]) {
        var vms = [PinboardCellViewModel]()
        for pin in pins {
            guard let cellViewModel = createCellViewModel(pin) else {
                continue
            }
            vms.append(cellViewModel)
        }

        cellViewModels = vms
        delegate?.onFetchCompleted()
    }

    func createCellViewModel(_ pin: Pin) -> PinboardCellViewModel? {
        guard let imageURL = pin.imageUrl?.imageURLString(of: pinSize) else {
            return nil
        }
        return PinboardCellViewModel(imageURL: imageURL)
    }

    func getCellViewModel(at indexPath: IndexPath) -> PinboardCellViewModel? {
        guard indexPath.row < cellViewModels.count else {
            return nil
        }

        return cellViewModels[indexPath.row]
    }

    func fetchPinImage(forPinAt indexPath: IndexPath) {
        loader.load(with: cellViewModels[indexPath.row].imageURL,
                    dataType: .image) {[weak self] (result: Swift.Result<UIImage, Error>) in
                        guard let self = self else {
                            return
                        }
                        switch result {
                        case .success(let image):
                            self.cellViewModels[indexPath.row].image = image
                        case .failure:
                            self.cellViewModels[indexPath.row].image = UIImage(asset: .notFound)
                        }

                        self.delegate?.onFetchCompleted(forItemIn: indexPath)
        }
    }
}

protocol PinboardViewModelDelegate {
    func onFetchCompleted(forItemIn indexPath: IndexPath)
    func onFetchCompleted()
}
