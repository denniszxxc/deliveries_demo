//
//  Delivery.swift
//  deliveries
//
//  Created by Dennis Li on 26/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import RealmSwift

class Delivery: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var itemDescription: String? // To avoid name conflict with NSObject's `description()`
    @objc dynamic var imageUrl: String?
    @objc dynamic var location: Location?

    convenience init?(json: [String: Any] ) {
        guard
            let id = json["id"] as? Int,
            let description = json["description"] as? String,
            let imageUrl = json["imageUrl"] as? String,
            let location = json["location"] as? [String: Any]
            else {
                return nil
        }

        self.init()
        self.id = id
        self.itemDescription = description
        self.imageUrl = imageUrl
        self.location = Location(json: location)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
