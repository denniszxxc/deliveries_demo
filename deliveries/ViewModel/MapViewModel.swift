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
    var annotationObservable: Observable<[DeliveryAnnotation]>?

    init() {
        annotationObservable = deliveryRepository.deliveryObservable()?
            .map({ deliveryResults in
                return deliveryResults.toArray()
                    .compactMap({ DeliveryAnnotation(delivery: $0) })
            })
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
