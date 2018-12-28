//
//  DeliveryDetailViewController.swift
//  deliveries
//
//  Created by Dennis Li on 27/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit
import RxSwift

class DeliveryDetailViewController: UIViewController {
    var viewModel: DeliveryDetailViewModel?
    var disposeBag = DisposeBag()

    override func loadView() {
        let view = DeliveryDetailView()
        view.dismissButton.addTarget(self, action: #selector(didClickDismiss), for: .touchUpInside)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let detailView = view as? DeliveryDetailView {
            viewModel?.titleObservable?.bind(to: detailView.titleLabel.rx.text).disposed(by: disposeBag)
            viewModel?.subtitleObservable?.bind(to: detailView.subtitleLabel.rx.text).disposed(by: disposeBag)

            viewModel?.invalidItemObservable.asObservable()
                .subscribe(onNext: {[weak self] (invalidDelivery) in
                    if invalidDelivery {
                        self?.showInvalidItemAlert()
                    }
                })
                .disposed(by: disposeBag)
        }
    }

    @objc func didClickDismiss(_: UIButton) {
        if let navigation = self.navigationController as? DeliveryNavigation {
            navigation.backToList()
        }
    }

    func showInvalidItemAlert() {
        let alert = UIAlertController.init(title: "Error", message: "Invalid Delivery", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Back", style: .default, handler: { [weak self] (_) in
            alert.dismiss(animated: true, completion: nil)
            if let navigation = self?.navigationController as? DeliveryNavigation {
                navigation.backToList()
            }
        }))

        if let navigation = self.navigationController as? DeliveryNavigation {
            navigation.showAlert(alert: alert)
        }
    }
}
