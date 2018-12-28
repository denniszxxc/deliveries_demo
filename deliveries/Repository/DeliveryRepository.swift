//
//  DeliveryRepository.swift
//  deliveries
//
//  Created by Dennis Li on 26/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

/*
 * Encapsulate data operations
 */

private let skipPageUserDefaultKey = "skipPageUserDefaultKey"
private let shouldFetchMoreUserDefaultKey = "shouldFetchMoreUserDefaultKey"

class DeliveryRepository {
    enum FetchDeliveryError: Error {
        case network
        case mapping
        case persist
    }
    static let DeliveryListFetchLimit = 20

    // Local State
    var skipPage: Int {
        didSet { userDefault.set(skipPage, forKey: skipPageUserDefaultKey) }
    }
    var shouldFetchMore: Bool {
        didSet { userDefault.set(shouldFetchMore, forKey: shouldFetchMoreUserDefaultKey) }
    }

    var deliveryListReqeust = DeliveryListReqeust()
    var userDefault = UserDefaults.standard

    init() {
        if userDefault.object(forKey: skipPageUserDefaultKey) != nil {
            skipPage = userDefault.integer(forKey: skipPageUserDefaultKey)
        } else {
            skipPage = 0
        }

        if userDefault.object(forKey: shouldFetchMoreUserDefaultKey) != nil {
            shouldFetchMore = userDefault.bool(forKey: shouldFetchMoreUserDefaultKey)
        } else {
            shouldFetchMore = true
        }
    }

    func fechDeliveries(cleanCachedDeliveries: Bool = false,
                        success: @escaping  () -> Void,
                        fail: @escaping (DeliveryRepository.FetchDeliveryError) -> Void) {

        let mainThreadFail = { (error: DeliveryRepository.FetchDeliveryError) in
            DispatchQueue.main.async { fail(error) }
        }

        deliveryListReqeust.start(
            limit: DeliveryRepository.DeliveryListFetchLimit,
            offset: cleanCachedDeliveries ? 0 : skipPage * DeliveryRepository.DeliveryListFetchLimit,
            success: {[weak self] deliveries in
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    if cleanCachedDeliveries {
                        realm.deleteAll()
                    }
                    realm.add(deliveries, update: true)
                    try realm.commitWrite()
                } catch {
                    mainThreadFail(.persist)
                    return
                }

                if cleanCachedDeliveries {
                    self?.skipPage = 0
                }
                if deliveries.count != 0 {
                    self?.skipPage += 1
                    self?.shouldFetchMore = true
                } else {
                    self?.shouldFetchMore = false
                }

                DispatchQueue.main.async {
                    success()
                }
            }, fail: mainThreadFail)
    }

    func shouldStartFetchNext(index: Int) -> Bool {
        return shouldFetchMore && ( (index + 1) >= skipPage * DeliveryRepository.DeliveryListFetchLimit)
    }

    func deliveryObservable() -> Observable<Results<Delivery>>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let deliveries = realm.objects(Delivery.self).sorted(byKeyPath: "id")
        return Observable
            .collection(from: deliveries)
    }

    func deliveryObservable(idList: [Int]) -> Observable<Results<Delivery>>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let deliveries = realm.objects(Delivery.self).filter("id IN %@", idList).sorted(byKeyPath: "id")
        return Observable
            .collection(from: deliveries)
    }

    func deliveryItemObservable(id: Int) ->  Observable<Results<Delivery>>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let deliveryResults = realm.objects(Delivery.self).filter("id == %@", id)
        return Observable.collection(from: deliveryResults)
    }
}
