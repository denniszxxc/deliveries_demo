//
//  DeliveryListViewModel.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
class DeliveryListViewModel {

    func fechDeliveries() {
        // TODO Call network

        DeliveryListReqeust.init().start(
            success: {
            // TODO: set different loading indiciation show hide state
            },
            fail: { (_) in
                // TODO: display different error
        })
    }

    func refreshDeliveries() {
        // TODO call api, clear data before writing new data
    }

    // TODO: pagination, success, failed alert, etc
}
