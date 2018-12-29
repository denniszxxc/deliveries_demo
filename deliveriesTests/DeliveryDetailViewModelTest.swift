//
//  DeliveryDetailViewModelTest.swift
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

class DeliveryDetailViewModelTest: XCTestCase {
    var viewModel: DeliveryDetailViewModel!
    var repositoryStub: DeliveryRepositroyStub!

    var selectedDelivery: Delivery!

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        repositoryStub = DeliveryRepositroyStub(fakeDeliveryCount: 10)
        let randomItemIndex = Int.random(in: 0..<repositoryStub.fakeDeliveries.count)
        selectedDelivery = repositoryStub.fakeDeliveries[randomItemIndex]

        viewModel = DeliveryDetailViewModel(deliveryId: selectedDelivery.id,
                                            deliveryRepository: repositoryStub)
    }

    func testObservables() {
        do {
            // When observing viewModels
            let title = try viewModel.titleObservable?.asObservable().toBlocking(timeout: 1).first()
            let subtitle = try viewModel.subtitleObservable?.asObservable().toBlocking(timeout: 1).first()
            let imageUrl = try viewModel.imageUrlObservable?.asObservable().toBlocking(timeout: 1).first()

            // Then Item should have expected properties content
            XCTAssertEqual(title, selectedDelivery.itemDescription)
            XCTAssertEqual(subtitle, selectedDelivery.location?.address)
            XCTAssertEqual(imageUrl, selectedDelivery.imageUrl)
        } catch {
            XCTFail("Should not throw when using toBlocking")
        }
    }

    func testDeliveryBecomeInvalid() {
        do {
            // Given a valid delivery object
            let isInvalid = try viewModel.invalidItemObservable.asObservable().toBlocking(timeout: 1).first()
            XCTAssertEqual(isInvalid, false)

            // When selected Delivery was invalid (deleted)
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()

            // Then observable should return true
            let isInvalidAfterDelete = try viewModel.invalidItemObservable.asObservable().toBlocking(timeout: 1).first()
            XCTAssertEqual(isInvalidAfterDelete, true)
        } catch {
            XCTFail("Should not throw when using toBlocking")
        }
    }
}
