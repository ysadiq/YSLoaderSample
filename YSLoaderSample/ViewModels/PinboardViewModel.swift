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
    var reloadForRow: Int? = nil

    private var cellViewModels: [PinboardCellViewModel] = [PinboardCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
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

    init(_ loader: YSLoaderProtocol = YSLoader.shared, pinSize: PinSize = .regular) {
        self.loader = loader
        self.pinSize = pinSize
    }

    convenience init(pinSize: PinSize) {
        self.init(YSLoader.shared, pinSize: pinSize)
    }

    func fetchPins() {
        loadingText = "Fetching Data"
        isLoading = true
        loader.load(with: APIEndpoint.Content.pinLongList,
                    dataType: .json) { (result: Result<Data, Error>) in
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

    func cancelImageFetching(forPinAt index: Int) {
        let url = cellViewModels[index].imageURL
        loader.cancelRequest(with: url)
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
    }

    func createCellViewModel(_ pin: Pin) -> PinboardCellViewModel? {
        guard let imageURL = pin.imageUrl?.imageURLString(of: pinSize) else {
            return nil
        }
        return PinboardCellViewModel(imageURL: imageURL)
    }

    @discardableResult
    func getCellViewModel(at row: Int) -> PinboardCellViewModel? {
        guard row < cellViewModels.count else {
            return nil
        }

        guard cellViewModels[row].image == nil else {
            return cellViewModels[row]
        }

        loader.load(with: cellViewModels[row].imageURL,
                    dataType: .image) { [weak self] (result: Result<UIImage, Error>) in
                        self?.isLoading = false
                        switch result {
                        case .success(let image):
                            self?.reloadForRow = row
                            self?.cellViewModels[row].image = image
                        case .failure(let error):
                            print(error)
                        }
        }
        return nil
    }
}

struct PinboardCellViewModel {
    let imageURL: String
    var image: UIImage?

    init(imageURL: String, image: UIImage? = nil) {
        self.imageURL = imageURL
        self.image = image
    }
}

// MARK: - PinboardCellViewModel (Helpers)
extension PinboardViewModel {
}
