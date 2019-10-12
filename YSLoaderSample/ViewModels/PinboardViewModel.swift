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

    init(_ loader: YSLoaderProtocol = YSLoader.shared) {
        self.loader = loader
    }

    func fetchPins(with imageSize: ImageSize) {
        loadingText = "Fetching Data"
        isLoading = true
        loader.load(with: APIEndpoint.Content.pins,
                    dataType: .json) { (result: Result<Data, Error>) in
                        switch result {
                        case .success(let json):
                            do {
                                let pins: [Pin] = try JSONDecoder().decode([Pin].self, from: json)
                                self.processFetchedPins(pins, with: imageSize)
                            } catch {}
                        case .failure(let error):
                            print(error)
                        }
        }
    }

    func cancelFetch() {
        loader.cancelRequest()
    }

    private func processFetchedPins(_ pins: [Pin], with size: ImageSize) {
        loadingText = "Fetching Images"
        isLoading = true
        for pin in pins {
            guard let imageURL = pin.imageUrl?.imageURLString(of: size) else {
                continue
            }
            loader.load(with: imageURL,
                        dataType: .image) { (result: Result<UIImage, Error>) in
                            self.isLoading = false
                            switch result {
                            case .success(let image):
                                self.cellViewModels.append(PinboardCellViewModel(image: image))
                            case .failure(let error):
                                print(error)
                            }
            }
        }
    }

    func getCellViewModel(at indexPath: IndexPath) -> PinboardCellViewModel? {
        guard indexPath.row < cellViewModels.count else {
            return nil
        }
        return cellViewModels[indexPath.row]
    }
}

struct PinboardCellViewModel {
    let image: UIImage
}

// MARK: - PinboardCellViewModel (Helpers)
extension PinboardViewModel {
}
