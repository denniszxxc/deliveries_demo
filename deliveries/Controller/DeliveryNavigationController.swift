//
//  DeliveryNavigationController.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit
import Pulley

protocol DeliveryNavigation: class {
    func showAlert(alert: UIAlertController)
    func showDeliveryDetail(deliveryId: Int, selectMapItem: Bool)
    func showSelectedDeliveryList(deliveryIdList: [Int])
    func backToList()
    func back()
}

class DeliveryNavigationController: UINavigationController {

    weak var mapViewSelect: MapViewSelectionAction?

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

    func showDeliveryDetail(deliveryId: Int, selectMapItem: Bool) {
        if let topDetailVC = self.topViewController as? DeliveryDetailViewController,
            topDetailVC.viewModel?.deliveryId == deliveryId {
            return // Avoid pushing same detail page twice
        }

        if selectMapItem {
            mapViewSelect?.selectDelivery(id: deliveryId)
        }

        let detailViewController = DeliveryDetailViewController()
        detailViewController.viewModel = DeliveryDetailViewModel(deliveryId: deliveryId)
        self.pushViewController(detailViewController, animated: true)

        if pulleyViewController?.drawerPosition != .partiallyRevealed {
            pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
        }
    }

    func showSelectedDeliveryList(deliveryIdList: [Int]) {
        let selecteListViewController = SelectedDeliveryListViewController()
        selecteListViewController.selectedDeliveryIds = deliveryIdList
        self.popToRootViewController(animated: false)
        self.pushViewController(selecteListViewController, animated: true)

        if pulleyViewController?.drawerPosition != .partiallyRevealed {
            pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
        }
    }

    func back() {
        self.popViewController(animated: true)
        if pulleyViewController?.drawerPosition != .partiallyRevealed {
            pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
        }
    }

    func backToList() {
        self.popToRootViewController(animated: true)
        mapViewSelect?.deselectAnyDelivery()

        if pulleyViewController?.drawerPosition != .partiallyRevealed {
            pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)
        }
    }
}
