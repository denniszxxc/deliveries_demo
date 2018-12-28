//
//  DeliveryRepositoryTest.swift
//  deliveriesTests
//
//  Created by Dennis Li on 28/12/2018.
//  Copyright © 2018年 Dennis Li. All rights reserved.
//

import XCTest
import RealmSwift
import RxTest
import RxBlocking

@testable import deliveries

class DeliveryRepositoryTest: XCTestCase {

    var deliveryRepository: DeliveryRepository!

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        deliveryRepository = DeliveryRepository()
        deliveryRepository.deliveryListReqeust = DeliveryListReqeustStub()

        // overwrite userdefault
        deliveryRepository.skipPage = 0
        deliveryRepository.shouldFetchMore = true
    }

    override func tearDown() {
        deliveryRepository = nil
    }

    func testFetchDeliveriesSuccess() {
        let deliveryCount = deliveryRepository.deliveryObservable()?
            .map({ $0.count })
            .take(1)

        // Given App has zero delivery items
        let currentDeliveryCount = try? deliveryCount?.toBlocking().last()! ?? -1
        XCTAssertEqual(currentDeliveryCount, 0, "Given realm have 0 item")

        let promise = expectation(description: "Sub request to complete")
        // When Start a fetch
        deliveryRepository.fechDeliveries(cleanCachedDeliveries: true, success: {
            // Then realm should have 10 Delivery Item
            let afterUpdateDeliveryCount = try?  deliveryCount?.toBlocking().last()! ?? -1
            XCTAssertEqual(afterUpdateDeliveryCount, 10, "Then realm should have 10 Delivery Item")

            XCTAssertEqual(self.deliveryRepository.skipPage, 1, "Skip Page become 1 after clean fetch")

            XCTAssertEqual(self.deliveryRepository.shouldFetchMore, true, "true fetchMove after clean fetch")

            promise.fulfill()
        }, fail: { (_) in
            XCTFail("Stub should not triiger fail block")
        })
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testFetchDeliveriesLastPage() {
        let deliveryCount = deliveryRepository.deliveryObservable()?
            .map({ $0.count })
            .take(1)

        // Given App skip page 0 & should fetch more
        XCTAssertEqual(self.deliveryRepository.skipPage, 0, "Skip Page default 0")
        XCTAssertEqual(self.deliveryRepository.shouldFetchMore, true)

        let promise = expectation(description: "Sub request to complete")
        // When Start a fetch with less than fetch limit
        deliveryRepository.deliveryListReqeust = {
            let subRequest = DeliveryListReqeustStub()
            subRequest.resultItemCount = 0
            return subRequest
        }()

        deliveryRepository.fechDeliveries(cleanCachedDeliveries: false, success: {
            // Then realm should have 0 Delivery Item
            let afterUpdateDeliveryCount = try?  deliveryCount?.toBlocking().last()! ?? -1
            XCTAssertEqual(afterUpdateDeliveryCount, 0, "Then realm should have 0 Delivery Item")

            XCTAssertEqual(self.deliveryRepository.skipPage, 0, "Skip Page remains 0 after fetch")
            XCTAssertEqual(self.deliveryRepository.shouldFetchMore, false,
                           "false fetchMore after receive 0 item")
            promise.fulfill()
        }, fail: { (_) in
            XCTFail("Stub should not triiger fail block")
        })
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testShouldFetchMore() {
        // Given App skip page 2 & should fetch more
        deliveryRepository.skipPage = 2
        deliveryRepository.shouldFetchMore = true
        XCTAssertEqual(self.deliveryRepository.skipPage, 2, "Skip Page 2")
        XCTAssertEqual(self.deliveryRepository.shouldFetchMore, true)

        let shouldFetchItemZero = self.deliveryRepository.shouldStartFetchNext(index: 0)
        XCTAssertFalse(shouldFetchItemZero)

        let testIndex = (2 * DeliveryRepository.DeliveryListFetchLimit - 1)
        let shouldFetchItem19 = self.deliveryRepository.shouldStartFetchNext(index: testIndex)
        XCTAssertTrue(shouldFetchItem19)
    }

    // TODO: Test add and fetch item
}
