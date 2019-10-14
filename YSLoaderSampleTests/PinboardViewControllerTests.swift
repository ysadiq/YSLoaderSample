//
//  PinboardViewControllerTests.swift
//  YSLoaderSampleTests
//
//  Created by Yahya Saddiq on 10/14/19.
//  Copyright © 2019 Yahya Saddiq. All rights reserved.
//

import XCTest

@testable import YSLoaderSample
@testable import YSLoader

class PinboardViewControllerTests: XCTestCase {
    private var sut: PinboardViewController!
    private var mockYSLoader: MockYSLoader!
    private var delegateExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        mockYSLoader = MockYSLoader()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "VFGDevicePermissionsViewController") as? PinboardViewController

        sut.viewModel = PinboardViewModel(mockYSLoader, pinSize: .regular)
        sut.loadViewIfNeeded()
    }

    func testInitViewModel() {
        sut.initViewModel()
        XCTAssertTrue(mockYSLoader.loadJSONIsCalled)
    }

    func testCellForRowAt() {
        sut.initViewModel()
        sut.viewModel.delegate = self
        let cellItem = sut.tableView(sut.tableView,
                                     cellForRowAt: IndexPath(item: 0, section: 0)) as? PinboardTableViewCell
        XCTAssertNotNil(cellItem)
        XCTAssertTrue(mockYSLoader.loadImageIsCalled)
    }

    override func tearDown() {
        sut = nil
        mockYSLoader = nil
        delegateExpectation = nil
        super.tearDown()
    }

}

extension PinboardViewControllerTests: PinboardViewModelDelegate {
    func onFetchCompleted(forItemIn indexPath: IndexPath) {
        let indexPath = IndexPath(item: 0, section: 0)
        _ = sut.tableView(sut.tableView,
                                     cellForRowAt: indexPath) as? PinboardTableViewCell
    }

    func onFetchCompleted() {
        delegateExpectation?.fulfill()
    }
}
