//
//  DeliveryListReqeust.swift
//  deliveriesTests
//
//  Created by Dennis Li on 28/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
@testable import deliveries

class DeliveryListReqeustStub: DeliveryListReqeust {

    var requestSuccess = true
    var resultItemCount = 10
    var failReason = DeliveryRepository.FetchDeliveryError.network

    private func sampleDeliveryList() -> [Delivery] {
        var result = [Delivery]()
        for count in 0 ..< resultItemCount {
            result.append(Delivery(value: ["id": count, "description": String(count)]))
        }
        return result
    }

    override func start(limit: Int = 20,
                        offset: Int = 0,
                        success: @escaping  ([Delivery]) -> Void,
                        fail: @escaping (DeliveryRepository.FetchDeliveryError) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(100)) {
            if self.requestSuccess {
                success(self.sampleDeliveryList())
            } else {
                fail(self.failReason)
            }
        }
    }
}
