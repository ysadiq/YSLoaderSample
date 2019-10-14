//
//  PinboardViewModelTests.swift
//  YSLoaderSampleTests
//
//  Created by Yahya Saddiq on 10/12/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import XCTest
@testable import YSLoaderSample

class PinboardViewModelTests: XCTestCase {
    var sut: PinboardViewModel!
    var mockYSLoader: MockYSLoader!

    override func setUp() {
        mockYSLoader = MockYSLoader()
        sut = PinboardViewModel(mockYSLoader)
    }

    override func tearDown() {
        sut = nil
        mockYSLoader = nil
    }

    func testCancelImageFetch() {
        sut.fetchPins()
        sut.cancelImageFetch(forPinAt: 0)
        XCTAssertTrue(mockYSLoader.cancelIsCalled)
    }

}
