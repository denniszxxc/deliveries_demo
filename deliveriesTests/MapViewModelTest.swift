//
//  MapViewModelTest.swift
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

class MapViewModelTest: XCTestCase {
    var mapViewModel: MapViewModel!
    var repositoryStub: DeliveryRepositroyStub!

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        mapViewModel = MapViewModel()
        repositoryStub = DeliveryRepositroyStub(fakeDeliveryCount: 10)
        mapViewModel.deliveryRepository = repositoryStub
    }

    func testAnnotationsList() {
        // Given the viewModel with stub data
        // When fetch the annotation list
        let annotations = try? mapViewModel.annotationObservable?.debug().toBlocking(timeout: 1).first()

        // Then annoations should be created by sub data
        XCTAssertEqual(annotations!!.count, repositoryStub.fakeDeliveries.count)
        zip(annotations!!, repositoryStub.fakeDeliveries).forEach { (annotation, delivery) in
            XCTAssertEqual(annotation.id, delivery.id)
            XCTAssertEqual(annotation.title, delivery.itemDescription)
            XCTAssertEqual(annotation.subtitle, delivery.location?.address)
            XCTAssertEqual(annotation.lng, delivery.location?.lng)
            XCTAssertEqual(annotation.lat, delivery.location?.lat)
        }
    }

    func testFocusSingleItemInAnnotationsList() {
        // Given the viewModel with 10 stub delivery
        let annotations = try? mapViewModel.annotationObservable?.debug().toBlocking(timeout: 1).first()
        XCTAssertEqual(annotations!!.count, repositoryStub.fakeDeliveries.count)

        // When focus single item
        let focusItemId = repositoryStub.fakeDeliveries[Int.random(in: 0..<repositoryStub.fakeDeliveries.count)].id
        mapViewModel.focusItem(id: focusItemId)

        // Then annoations result should be 1 now
        let annotationsAfterFocus = try? mapViewModel.annotationObservable?.debug().toBlocking(timeout: 1).first()
        XCTAssertEqual(annotationsAfterFocus!!.count, 1)
        XCTAssertEqual(annotationsAfterFocus!!.first?.id, focusItemId)

        // When Unfocus
        mapViewModel.stopFocusing()

        // Then annotaion list should become normal again
        let annotationsStopFocus = try? mapViewModel.annotationObservable?.debug().toBlocking(timeout: 1).first()
        XCTAssertEqual(annotationsStopFocus!!.count, repositoryStub.fakeDeliveries.count)
    }

}
