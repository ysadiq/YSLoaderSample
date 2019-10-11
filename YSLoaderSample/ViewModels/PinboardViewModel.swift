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
        isLoading = true
        loader.json(with: APIEndpoint.Content.pastebin) { [weak self] data in
            guard let self = self else {
                return
            }
            self.isLoading = false
            guard let data = data else {
                return
            }

            do {
                let pins: [Pin] = try JSONDecoder().decode([Pin].self, from: data)
                self.processFetchedPins(pins, with: imageSize)
            } catch {

            }

        }
    }

    private func imageURLString(of pin: Pin, with size: ImageSize) -> String? {
        var imageURL: String?
        switch size {
        case .raw:
            imageURL = pin.imageUrl?.raw
        case .full:
            imageURL = pin.imageUrl?.full
        case .regular:
            imageURL = pin.imageUrl?.regular
        case .small:
            imageURL = pin.imageUrl?.small
        case .thump:
            imageURL = pin.imageUrl?.thumb
        case .large:
            imageURL = pin.imageUrl?.large
        case .medium:
            imageURL = pin.imageUrl?.medium
        }

        return imageURL
    }
    private func processFetchedPins(_ pins: [Pin], with size: ImageSize) {
        var vms = [PinboardCellViewModel]()

        for pin in pins {
            guard let imageURL = imageURLString(of: pin, with: size) else {
                continue
            }

            loader.image(with: imageURL) { (image) in
                guard let image = image else {
                    return
                }
                vms.append(PinboardCellViewModel(image: image))
            }
        }
        self.cellViewModels = vms
    }

//    func createCellViewModel(_ pinboard: PinboardModel) -> PinboardCellViewModel? {
//        guard let imageURL = pinboard.imageURL else {
//            return nil
//        }
//        loader.image(with: imageURL) { (image) in
//            <#code#>
//        }
//        return PinboardCellViewModel(image: pinboard.imageURL)
//    }

    /// Fetches all required permissions
    /// on completion, sets fetched permissions to permissions list
//    func fetchImages() {
//        self.isLoading = true
//        loader.json(with: "http://pastebin.com/raw/wgkJgazE") { (json) in
//            guard let json = json as? [String: Any],
//                let model: T = JSONDecoder.parseJson(json) else {
//                    completion(nil, MVAError.parse)
//                    return
//            }
//            guard let image = image else {
//                return
//            }
//            images.append(image)
//        }
//    }

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
