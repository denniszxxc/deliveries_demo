//
//  MapViewModel.swift
//  deliveries
//
//  Created by Dennis Li on 28/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import MapKit

class MapViewModel {

    private let deliveryRepository = DeliveryRepository()
    private let focusedDeliveryId = BehaviorSubject<Int?>(value: nil)
    var annotationObservable: Observable<[DeliveryAnnotation]>?

    init() {
        annotationObservable = focusedDeliveryId.asObservable()
            .flatMapLatest({ (focusdId: Int?)  -> Observable<Results<Delivery>> in
                if let focusdId = focusdId {
                    return self.deliveryRepository.deliveryObservable(idList: [focusdId])!
                } else {
                    return self.deliveryRepository.deliveryObservable()!
                }
            }).map({ (deliveryResults: Results<Delivery>) -> [DeliveryAnnotation] in
                return deliveryResults.toArray().compactMap({ DeliveryAnnotation(delivery: $0) })
            })

    }

    public func focusingItemId() -> Int? {
        return (try? focusedDeliveryId.value()) ?? nil
    }

    public func focusItem(id: Int?) {
        focusedDeliveryId.onNext(id)
    }

    public func stopFocusing() {
        if focusingItemId() != nil {
            focusedDeliveryId.onNext(nil)
        }
    }

    class DeliveryAnnotation: NSObject, MKAnnotation {
        let id: Int
        let lat: Double
        let lng: Double

        var title: String?
        var subtitle: String?

        init?(delivery: Delivery) {
            guard
                !delivery.isInvalidated,
                let location = delivery.location,
                !location.isInvalidated else {
                    return nil
            }
            id = delivery.id
            lat = location.lat
            lng = location.lng

            title = delivery.itemDescription
            subtitle = location.address
        }

        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D.init(latitude: lat,
                                               longitude: lng)
        }
    }
}
