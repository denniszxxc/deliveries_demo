//
//  DeliveryNavigationController.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

protocol DeliveryNavigation: class {
    func showAlert(alert: UIAlertController)
    func showDeliveryDetail(deliveryId: Int)
    func backToList()
}

class DeliveryNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    private func setupNavBar() {
        setNavigationBarHidden(true, animated: false)
    }
}

extension DeliveryNavigationController: DeliveryNavigation {

    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }

    func showDeliveryDetail(deliveryId: Int) {
        let detailViewController = DeliveryDetailViewController()
        detailViewController.viewModel = DeliveryDetailViewModel(deliveryId: deliveryId)
        self.pushViewController(detailViewController, animated: true)
    }

    func backToList() {
        self.popToRootViewController(animated: true)
    }
}
