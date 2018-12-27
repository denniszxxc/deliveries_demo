//
//  DeliveryListRequest.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation

class DeliveryListReqeust {
    static let queryLimit = "limit"
    static let queryOffset = "offset"

    let host = "https://mock-api-mobile.dev.lalamove.com"
    let endpoint = "/deliveries"
    let httpMethod = "GET"

    lazy var responseMapper = DeliveryListResponseMapper()

    private func requestUrl(_ limit: Int, _ offset: Int) -> URL? {
        guard var urlComponents = URLComponents.init(string: "\(host)\(endpoint)") else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem.init(name: DeliveryListReqeust.queryLimit, value: String(limit)),
            URLQueryItem.init(name: DeliveryListReqeust.queryOffset, value: String(offset))
        ]
        return urlComponents.url
    }

    func start(limit: Int = 20,
               offset: Int = 0,
               success: @escaping  ([Delivery]) -> Void,
               fail: @escaping (DeliveryRepository.FetchDeliveryError) -> Void) {
        guard let requestUrl = requestUrl(limit, offset) else {
            return
        }

        let urlRequest = URLRequest.init(url: requestUrl)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                fail(.network)
                return
            }

            // Map data to into data model
            do {
                let deliveryList = try self.responseMapper.map(data: data)
                success(deliveryList)
            } catch {
                fail(.mapping)
            }
        }
        task.resume()
    }
}
