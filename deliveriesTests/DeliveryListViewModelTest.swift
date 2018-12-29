//
//  DeliveryListViewModelTest.swift
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

class DeliveryListViewModelTest: XCTestCase {
    var viewModel: DeliveryListViewModel!
    var repositoryStub: DeliveryRepositroyStub!

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        repositoryStub = DeliveryRepositroyStub(fakeDeliveryCount: 20)
        viewModel = DeliveryListViewModel(deliveryRepository: repositoryStub)
    }

    func testDeliveryObservable() {
        do {
            // When observing viewModels
            let deliveries = try viewModel.deliveryObservable?.asObservable().toBlocking(timeout: 1).first()

            // Then Item should have expected properties content
            XCTAssertEqual(deliveries?.map({ $0.id }), repositoryStub.fakeDeliveries.map({ $0.id }))

            XCTAssertEqual(viewModel.deliveryIdAt(index: 0), repositoryStub.fakeDeliveries[0].id)
            XCTAssertEqual(viewModel.deliveryIdAt(index: 1), repositoryStub.fakeDeliveries[1].id)
            XCTAssertEqual(viewModel.deliveryIdAt(index: 19), repositoryStub.fakeDeliveries[19].id)
        } catch {
            XCTFail("Should not throw when using toBlocking")
        }
    }

    func testRefreshLoading() {
        do {
            // Given no loading viewModel
            let cleanFetchloading = viewModel.cleanFetchloading.asObserver().take(2)

            // when start clean fetch
            viewModel.refreshDeliveries()

            // Then isLoading should be true, and then false after fetching complete
            let cleanFetchLoadingEvents = try cleanFetchloading.toBlocking(timeout: 3).toArray()
            XCTAssertEqual(cleanFetchLoadingEvents, [true, false])
        } catch {
            XCTFail("Should not throw when using rxBlocking")
        }
    }

    func testPagingLoading() {
        do {
            // Given no loading viewModel
            let isLoading = viewModel.loading.asObserver().take(2)

            // when start paging request
            viewModel.fetchMoreDeliveriesIfNeeded(index: 19)

            // Then isLoading should be true, and then false after fetching complete
            let loadingEvents = try isLoading.toBlocking(timeout: 3).toArray()
            XCTAssertEqual(loadingEvents, [true, false])
        } catch {
            XCTFail("Should not throw when using rxBlocking")
        }
    }
}
