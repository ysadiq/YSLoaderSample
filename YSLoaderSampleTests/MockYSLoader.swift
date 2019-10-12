//
//  MockYSLoader.swift
//  YSLoaderSampleTests
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import Foundation
@testable import YSLoader

public class MockYSLoader: YSLoaderProtocol {
    var imageIsCalled: Bool = false
    var jsonIsCalled: Bool = false
    var cancelIsCalled: Bool = false

    public func load<T>(with url: String, dataType: DataType, completionHandler: @escaping (Result<T, Error>) -> Void) {
        load(with: url, parameters: nil, dataType: dataType, completionHandler: completionHandler)
    }

    public func load<T>(with url: String, parameters: [String : String]?, dataType: DataType, completionHandler: @escaping (Result<T, Error>) -> Void) {
        switch dataType {
        case .image:
            imageIsCalled = true
        case .json:
            jsonIsCalled = true
        default:
            break
        }
    }

    public func cancelRequest() {
        cancelIsCalled = true
    }
}
