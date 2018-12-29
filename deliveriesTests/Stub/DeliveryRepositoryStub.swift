//
//  DeliveryRepositoryStub.swift
//  deliveriesTests
//
//  Created by Dennis Li on 29/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
@testable import deliveries
import RealmSwift

class DeliveryRepositroyStub: DeliveryRepository {

    var fakeDeliveries = [Delivery]()

    override init() {
        super.init()

        self.skipPage = 0
        self.shouldFetchMore = true
    }

    convenience init(fakeDeliveryCount: Int) {
        self.init()
        self.insertFakeDeliveries(fakeDeliveryCount)
    }

    override func fechDeliveries(cleanCachedDeliveries: Bool,
                                 success: @escaping () -> Void,
                                 fail: @escaping (DeliveryRepository.FetchDeliveryError) -> Void) {
        DispatchQueue.main.async { fail(.network) }
    }

    private func insertFakeDeliveries(_ amount: Int) {
        guard let realm = try? Realm() else {
            return
        }
        realm.beginWrite()
        for amount in 0..<amount {
            let delivery = Delivery.init()
            delivery.id = amount
            delivery.itemDescription = "item \(String(amount))"
            delivery.imageUrl = "https://via.placeholder.com/300"
            delivery.location = Location()
            delivery.location?.address = "location address \(String(amount))"
            delivery.location?.lat = Double.random(in: -90...90)
            delivery.location?.lng = Double.random(in: -180...180)
            realm.add(delivery, update: true)

            fakeDeliveries.append(delivery)
        }
        try? realm.commitWrite()
    }
}
