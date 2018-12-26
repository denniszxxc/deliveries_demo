//
//  Delivery.swift
//  deliveries
//
//  Created by Dennis Li on 26/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation

class Delivery {
    var id: Int = 0
    var description: String?
    var imageUrl: String?
    var location: Location?

    init?(json: [String: Any] ) {
        guard
            let id = json["id"] as? Int,
            let description = json["description"] as? String,
            let imageUrl = json["imageUrl"] as? String,
            let location = json["location"] as? [String: Any]
        else {
            return nil
        }

        self.id = id
        self.description = description
        self.imageUrl = imageUrl
        self.location = Location(json: location)
    }
}
