//
//  DeliveryAnnotationView.swift
//  deliveries
//
//  Created by Dennis Li on 28/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import Foundation
import MapKit

class DeliveryAnnotationView: MKMarkerAnnotationView {

    static let DeliveryClusterID = "DeliveryClusterID"

    static let ReuseID = "deliveryAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = DeliveryAnnotationView.DeliveryClusterID
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        subtitleVisibility = .adaptive
    }
}
