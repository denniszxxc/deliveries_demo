//
//  DeliveryListResponseMapperTest.swift
//  deliveriesTests
//
//  Created by Dennis Li on 29/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import XCTest
@testable import deliveries

class DeliveryListReponseMapperTest: XCTestCase {
    var mapper = DeliveryListResponseMapper()

    func testMapperHappyCase() {
        let data = """
        [{"id":0,"description":"Deliver documents to Andrio","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-4.jpeg","location":{"lat":22.336093,"lng":114.155288,"address":"Cheung Sha Wan"}},{"id":1,"description":"Deliver parcel to Leviero","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-7.jpeg","location":{"lat":22.335538,"lng":114.176169,"address":"Kowloon Tong"}},{"id":2,"description":"Deliver toys to Luqman","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-7.jpeg","location":{"lat":22.336093,"lng":114.155288,"address":"Cheung Sha Wan"}},{"id":3,"description":"Deliver documents to Andrio","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-7.jpeg","location":{"lat":22.336093,"lng":114.155288,"address":"Cheung Sha Wan"}},{"id":4,"description":"Deliver documents to Andrio","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-5.jpeg","location":{"lat":22.319181,"lng":114.170008,"address":"Mong Kok"}},{"id":5,"description":"Deliver documents to Andrio","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-3.jpeg","location":{"lat":22.336093,"lng":114.155288,"address":"Cheung Sha Wan"}},{"id":6,"description":"Deliver documents to Andrio","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-7.jpeg","location":{"lat":22.336093,"lng":114.155288,"address":"Cheung Sha Wan"}},{"id":7,"description":"Deliver wine to Kenneth","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-8.jpeg","location":{"lat":22.319181,"lng":114.170008,"address":"Mong Kok"}},{"id":8,"description":"Deliver parcel to Leviero","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-1.jpeg","location":{"lat":22.336093,"lng":114.155288,"address":"Cheung Sha Wan"}},{"id":9,"description":"Deliver documents to Andrio","imageUrl":"https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-1.jpeg","location":{"lat":22.336093,"lng":114.155288,"address":"Cheung Sha Wan"}}]
        """.data(using: .utf8) // swiftlint:disable:previous line_length

        let resultDelivery = try? mapper.map(data: data)

        XCTAssertEqual(resultDelivery?.count, 10)
    }

    func testZeroItem() {
        let data = "[]".data(using: .utf8)
        let resultDelivery = try? mapper.map(data: data)
        XCTAssertEqual(resultDelivery?.count, 0)
    }

    func testEmptyItem() {
        let data = "[{}]".data(using: .utf8)
        let resultDelivery = try? mapper.map(data: data)
        XCTAssertEqual(resultDelivery?.count, 0)
    }

    func testWrongFormt() {
        let data = "{ \"abe\": 1 }".data(using: .utf8)

        XCTAssertThrowsError(try mapper.map(data: data)) { error in
            XCTAssertTrue(error as? DeliveryRepository.FetchDeliveryError != nil)
            XCTAssertEqual(error as? DeliveryRepository.FetchDeliveryError,
                           DeliveryRepository.FetchDeliveryError.mapping)
        }
    }
}
