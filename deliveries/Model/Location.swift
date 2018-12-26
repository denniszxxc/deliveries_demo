//
//  Location.swift
//  deliveries
//
//  Created by Dennis Li on 26/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
struct Location {
    var lat: Double
    var lng: Double
    var address: String?

    init?(json: [String: Any] ) {
        guard
            let lat = json["lat"] as? Double,
            let lng = json["lng"] as? Double,
            let address = json["address"] as? String
            else {
                return nil
        }

        self.lat = lat
        self.lng = lng
        self.address = address
    }
}
