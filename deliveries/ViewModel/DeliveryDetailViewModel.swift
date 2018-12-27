//
//  DeliveryDetailViewModel.swift
//  deliveries
//
//  Created by Dennis Li on 27/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RxSwift

class DeliveryDetailViewModel {
    let deliveryId: Int

    let deliveryRepository = DeliveryRepository()

    private var deliveryItemObservable: Observable<Delivery>?

    var invalidItemObservable = BehaviorSubject<Bool>(value: false)
    var titleObservable: Observable<String>?
    var subtitleObservable: Observable<String>?

    init(deliveryId: Int) {
        self.deliveryId = deliveryId

        self.deliveryItemObservable = deliveryRepository.deliveryItemObservable(id: deliveryId)

        guard let deliveryItemObservable = self.deliveryItemObservable else {
            // TODO: handle delivery item not found
            return
        }

        titleObservable = deliveryItemObservable.map({ $0.itemDescription ?? "" })
        subtitleObservable = deliveryItemObservable.map({ $0.location?.address ?? "" })
    }
}
