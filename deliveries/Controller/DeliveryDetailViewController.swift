//
//  DeliveryDetailViewController.swift
//  deliveries
//
//  Created by Dennis Li on 27/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

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
            viewModel?.imageUrlObservable?.subscribe(onNext: { [weak self] (url) in
                self?.setImage(url: url)
            }).disposed(by: disposeBag)

            viewModel?.invalidItemObservable.asObservable()
                .subscribe(onNext: {[weak self] (invalidDelivery) in
                    if invalidDelivery {
                        self?.showInvalidItemAlert()
                    }
                })
                .disposed(by: disposeBag)
        }
    }

    func setImage(url: String?) {
        if let detailView = view as? DeliveryDetailView, let imageUrl = url {
            let url = URL(string: imageUrl)
            detailView.imageView.kf.indicatorType = .activity
            detailView.imageView.kf.setImage(with: url,
                                             completionHandler: { (result) in
                                                if let resultImage = result.value?.image.size {
                                                    let imageRatio = resultImage.width / resultImage.height
                                                    detailView.updateImageViewAspectRatio(ratio: imageRatio)
                                                }

            })
        }
    }

    @objc func didClickDismiss(_: UIButton) {
        if let navigation = self.navigationController as? DeliveryNavigation {
            navigation.backToList()
        }
    }

    func showInvalidItemAlert() {
        let title = NSLocalizedString("delivery_detail__alert_error", comment: "")
        let message = NSLocalizedString("delivery_detail__alert_message", comment: "")
        let back = NSLocalizedString("delivery_detail__alert_back", comment: "")

        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: back, style: .default, handler: { [weak self] (_) in
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
