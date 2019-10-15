//
//  MockYSLoader.swift
//  YSLoaderSampleTests
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
import XCTest
@testable import YSLoader
@testable import YSLoaderSample

public class MockYSLoader: YSLoaderProtocol {
    var loadImageIsCalled: Bool = false
    var loadJSONIsCalled: Bool = false
    var cancelIsCalled: Bool = false

    public func load<T>(with url: String, dataType: DataType, completionHandler: @escaping (Swift.Result<T, Error>) -> Void) {
        load(with: url, parameters: nil, dataType: dataType, completionHandler: completionHandler)
    }

    public func load<T>(with url: String, parameters: [String : String]?, dataType: DataType, completionHandler: @escaping (Swift.Result<T, Error>) -> Void) {
        switch dataType {
        case .image:
            loadImageIsCalled = true
            guard let image = UIImage(asset: .notFound) as? T else {
                return
            }
            completionHandler(Swift.Result.success(image))
        case .json:
            guard let fileUrl = Bundle.main.url(forResource: "pinStub", withExtension: "json"),
                let jsonData = try? Data(contentsOf: fileUrl) else {
                    XCTFail("Error reading from file")
                    return
            }
            guard let data = jsonData as? T else {
                return
            }
            completionHandler(Swift.Result.success(data))
            loadJSONIsCalled = true
        default:
            break
        }
    }
    
    public func cancelRequest(of url: String) {
        cancelIsCalled = true
    }
}
