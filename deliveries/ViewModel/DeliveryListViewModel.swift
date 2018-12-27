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
    let cleanFetchloading = BehaviorSubject<Bool>(value: false)
    let fetchDeliveriesError = BehaviorSubject<DeliveryRepository.FetchDeliveryError?>(value: nil)

    private func isLoading() -> Bool {
        let loadingValue = try? loading.value()
        return loadingValue ?? false
    }

    func refreshDeliveries() {
        if isLoading() {
            return
        }
        fetchDelivery(cleanFetch: true)
    }

    func fetchMoreDeliveriesIfNeeded(index: Int) {
        if !isLoading() && deliveryRepository.shouldStartFetchNext(index: index) {
            fetchDelivery(cleanFetch: false)
        }
    }

    private func fetchDelivery(cleanFetch: Bool) {
        loading.onNext(true)
        if cleanFetch {
            cleanFetchloading.onNext(true)
        }

        deliveryRepository.fechDeliveries(cleanCachedDeliveries: cleanFetch, success: { [weak self] in
            self?.loading.onNext(false)
            if cleanFetch {
                self?.cleanFetchloading.onNext(false)
            }
            }, fail: { [weak self] error in
                self?.loading.onNext(false)
                if cleanFetch {
                    self?.cleanFetchloading.onNext(false)
                }
                self?.fetchDeliveriesError.onNext(error)
        })
    }
}
