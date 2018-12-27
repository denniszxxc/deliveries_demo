//
//  DeliveryListViewModel.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RxSwift

class DeliveryListViewModel {

    let deliveryRepository = DeliveryRepository()
    let loading = BehaviorSubject<Bool>(value: false)
    let fetchDeliveriesError = BehaviorSubject<DeliveryRepository.FetchDeliveryError?>(value: nil)

    func refreshDeliveries() {
        if let isLoading = try? loading.value(), isLoading == true {
            return
        }

        fetchDelivery(cleanFetch: true)
    }

    private func fetchDelivery(cleanFetch: Bool) {
        loading.onNext(true)

        deliveryRepository.fechDeliveries(cleanCachedDeliveries: cleanFetch, success: { [weak self] in
            self?.loading.onNext(false)
            }, fail: { [weak self] error in
                self?.loading.onNext(false)
                self?.fetchDeliveriesError.onNext(error)
        })
    }

    func fetchMoreDeliveriesIfNeeded(indices: [Int]) {
        if let maxIndex = indices.max(), deliveryRepository.shouldStartFetchNext(index: maxIndex) {
            fetchDelivery(cleanFetch: false)
        }
    }
}
