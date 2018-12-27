//
//  DeliveryListViewModel.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class DeliveryListViewModel {

    private let deliveryRepository = DeliveryRepository()
    var deliveryObservable: Observable<Results<Delivery>>?
    let loading = BehaviorSubject<Bool>(value: false)
    let cleanFetchloading = BehaviorSubject<Bool>(value: false)
    let fetchDeliveriesError = BehaviorSubject<DeliveryRepository.FetchDeliveryError?>(value: nil)

    private var deliveryResult: Results<Delivery>?

    init() {
        deliveryObservable = deliveryRepository.deliveryObservable()?
            .do(onNext: { [weak self] (deliveryResult) in
                self?.deliveryResult = deliveryResult
            })
    }

    private func isLoading() -> Bool {
        let loadingValue = try? loading.value()
        return loadingValue ?? false
    }

    func refreshDeliveries(success: (() -> Void)? = nil) {
        if isLoading() {
            return
        }
        fetchDelivery(cleanFetch: true, success: success)
    }

    func fetchMoreDeliveriesIfNeeded(index: Int) {
        if !isLoading() && deliveryRepository.shouldStartFetchNext(index: index) {
            fetchDelivery(cleanFetch: false)
        }
    }

    private func fetchDelivery(cleanFetch: Bool, success: (() -> Void)? = nil) {
        loading.onNext(true)
        if cleanFetch {
            cleanFetchloading.onNext(true)
        }

        deliveryRepository.fechDeliveries(cleanCachedDeliveries: cleanFetch, success: { [weak self] in
            self?.loading.onNext(false)
            if cleanFetch {
                self?.cleanFetchloading.onNext(false)
            }
            success?()
            }, fail: { [weak self] error in
                self?.loading.onNext(false)
                if cleanFetch {
                    self?.cleanFetchloading.onNext(false)
                }
                self?.fetchDeliveriesError.onNext(error)
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
