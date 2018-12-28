//
//  DeliveryDetailViewModel.swift
//  deliveries
//
//  Created by Dennis Li on 27/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class DeliveryDetailViewModel {
    let deliveryId: Int

    let deliveryRepository = DeliveryRepository()

    private var deliveryItemObservable: Observable<Results<Delivery>>?

    var invalidItemObservable: Observable<Bool>
    var titleObservable: Observable<String>?
    var subtitleObservable: Observable<String>?
    var imageUrlObservable: Observable<String?>?

    init(deliveryId: Int) {
        self.deliveryId = deliveryId

        self.deliveryItemObservable = deliveryRepository.deliveryItemObservable(id: deliveryId)

        guard let deliveryItemObservable = self.deliveryItemObservable else {
            self.invalidItemObservable = BehaviorSubject<Bool>(value: true)
            return
        }

        self.titleObservable = deliveryItemObservable.map({ $0.first?.itemDescription ?? "" })
        self.subtitleObservable = deliveryItemObservable.map({ $0.first?.location?.address ?? "" })
        self.imageUrlObservable = deliveryItemObservable.map({ $0.first?.imageUrl })

        self.invalidItemObservable = deliveryItemObservable.map({ (deliveryResults) -> Bool in
            guard let first =  deliveryResults.first else {
                return true
            }
            return first.isInvalidated
        })
    }
}
