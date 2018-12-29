//
//  SelectedDeliveryListViewModelTest.swift
//  deliveriesTests
//
//  Created by Dennis Li on 29/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import XCTest

import RealmSwift
import RxTest
import RxBlocking

@testable import deliveries

class SelectedDeliveryListViewModelTest: XCTestCase {
    var viewModel: SelectedDeliveryListViewModel!
    var repositoryStub: DeliveryRepositroyStub!

    var selectedDeliveryIds: [Int]!

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        repositoryStub = DeliveryRepositroyStub(fakeDeliveryCount: 10)
        selectedDeliveryIds = repositoryStub.fakeDeliveries[0...3].map({ $0.id })

        viewModel = SelectedDeliveryListViewModel(selectedDeliveresId: selectedDeliveryIds,
                                                  deliveryRepository: repositoryStub)
    }

    func testDeliveryObservable() {
        do {
            // When observing viewModels
            let deliveries = try viewModel.deliveryObservable?.asObservable().toBlocking(timeout: 1).first()
            let deliveryesCount = try viewModel.deliveryCountObservable?.asObservable().toBlocking(timeout: 1).first()

            // Then Item should have expected properties content
            XCTAssertEqual(deliveries?.map({ $0.id }), selectedDeliveryIds)
            XCTAssertEqual(deliveryesCount, selectedDeliveryIds.count)

            XCTAssertEqual(viewModel.deliveryIdAt(index: 0), selectedDeliveryIds[0])
            XCTAssertEqual(viewModel.deliveryIdAt(index: 1), selectedDeliveryIds[1])
            XCTAssertEqual(viewModel.deliveryIdAt(index: 3), selectedDeliveryIds[3])
        } catch {
            XCTFail("Should not throw when using toBlocking")
        }
    }
}
