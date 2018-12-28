//
//  SelectedDeliveryListViewModel.swift
//  deliveries
//
//  Created by Dennis Li on 28/12/2018.
//  Copyright © 2018年 Dennis Li. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class SelectedDeliveryListViewModel {
    var selectedDeliveresId: [Int]

    private let deliveryRepository = DeliveryRepository()
    var deliveryObservable: Observable<Results<Delivery>>?
    var deliveryCountObservable: Observable<Int>?

    private var deliveryResult: Results<Delivery>?

    init(selectedDeliveresId: [Int]) {
        self.selectedDeliveresId = selectedDeliveresId
        deliveryObservable = deliveryRepository.deliveryObservable(idList: selectedDeliveresId)?
            .do(onNext: { [weak self] (deliveryResult) in
                self?.deliveryResult = deliveryResult
            })

        deliveryCountObservable = deliveryObservable?.map({ (results) -> Int in
            return results.count
        })
    }

    public func deliveryIdAt(index: Int) -> Int? {
        guard let deliveryResult = deliveryResult,
            !deliveryResult.isInvalidated,
            deliveryResult.count > index else {
                return nil
        }
        return deliveryResult.toArray()[index].id
    }
}
