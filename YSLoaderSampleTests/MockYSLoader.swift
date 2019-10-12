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

    public func image(with url: String, completion: @escaping (UIImage?) -> Void) {
        imageIsCalled = true
    }

    public func json(with url: String, completion: @escaping (Data?) -> Void) {
        jsonIsCalled = true
    }

    public func cancelRequest() {
        cancelIsCalled = true
    }
}
