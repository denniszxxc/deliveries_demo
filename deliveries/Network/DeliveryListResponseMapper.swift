//
//  DeliveryListResponseMapper.swift
//  deliveries
//
//  Created by Dennis Li on 26/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation

// Deserialize JSON data into swift object
class DeliveryListResponseMapper {

    func map(data: Data?) throws -> [Delivery] {
        guard let data = data else {
            return []
        }

        var resultItems: [Delivery] = []
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            for item in json {
                if let delivery = Delivery(json: item) {
                    resultItems.append(delivery)
                }
            }
        } else {
            // TODO: handle mapping error
        }

        return resultItems
    }
}
