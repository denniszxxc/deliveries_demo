//
//  Location.swift
//  deliveries
//
//  Created by Dennis Li on 26/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0
    @objc dynamic var address: String?

    convenience init?(json: [String: Any] ) {
        guard
            let lat = json["lat"] as? Double,
            let lng = json["lng"] as? Double,
            let address = json["address"] as? String
            else {
                return nil
        }

        self.init()
        self.lat = lat
        self.lng = lng
        self.address = address
    }
}
