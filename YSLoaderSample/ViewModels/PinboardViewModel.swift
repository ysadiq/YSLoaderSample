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
    var loader: YSLoader
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

    init(_ loader: YSLoader = YSLoader()) {
        self.loader = loader
    }

    func fetchPins(with imageSize: ImageSize) {
        loadingText = "Fetching Data"
        isLoading = true
        loader.json(with: APIEndpoint.Content.pins) { [weak self] data in
            guard let self = self,
                let data = data else {
                    return
            }
            self.isLoading = false
            do {
                let pins: [Pin] = try JSONDecoder().decode([Pin].self, from: data)
                self.processFetchedPins(pins, with: imageSize)
            } catch {

            }
        }
    }

    private func processFetchedPins(_ pins: [Pin], with size: ImageSize) {
//        var vms = [PinboardCellViewModel]()

        loadingText = "Fetching Images"
        isLoading = true
        for pin in pins {
            guard let imageURL = pin.imageUrl?.imageURLString(of: size) else {
                continue
            }
            loader.image(with: imageURL) { (image) in
                self.isLoading = false
                guard let image = image else {
                    return
                }
//                vms.append(PinboardCellViewModel(image: image))
                self.cellViewModels.append(PinboardCellViewModel(image: image))
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
