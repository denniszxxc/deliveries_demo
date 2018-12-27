//
//  DeliveryListViewController
//  deliveries
//
//  Created by Dennis Li on 20/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DeliveryListViewController: UIViewController {
    var viewModel = DeliveryListViewModel()

    weak var tableView: UITableView!
    weak var activityIndicator: UIActivityIndicatorView!

    var disposeBag = DisposeBag()

    override func loadView() {
        let view = DeliveryListView()
        view.tableView.delegate = self
        view.refreshButton.addTarget(self, action: #selector(didClickRefresh), for: .touchUpInside)

        self.view = view
        self.tableView = view.tableView
        self.activityIndicator = view.centeredOverlayActivityIndicator
    }

    func view() -> DeliveryListView? {
        return self.view as? DeliveryListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.refreshDeliveries {
            self.tableView.scrollRectToVisible(CGRect.zero, animated: false)
        }

        setupObservers()
    }

    @objc func didClickRefresh(_: UIButton) {
        viewModel.refreshDeliveries()
    }

    private func setupObservers() {
        viewModel.deliveryObservable?
            .bind(to:
                tableView.rx.items(cellIdentifier: DeliveryTableViewCell.cellIdentifier,
                                   cellType: DeliveryTableViewCell.self)) { (_, element, cell) in
                                    cell.bind(delivery: element)}
            .disposed(by: disposeBag)

        viewModel.fetchDeliveriesError
            .subscribe(onNext: { [weak self] error in
                guard let error = error else {
                    return
                }
                self?.showErrorAlert(error)
            })
            .disposed(by: disposeBag)

        viewModel.loading.asObserver()
            .subscribe(onNext: { (loading) in
                if loading {
                    self.view()?.showTableViewLoadingFooterView()
                } else {
                    self.view()?.hidebleViewLoadingFooterView()
                }

                UIApplication.shared.isNetworkActivityIndicatorVisible = loading
            })
            .disposed(by: disposeBag)

        viewModel.cleanFetchloading
            .map({ !$0 })
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func showErrorAlert(_ error: DeliveryRepository.FetchDeliveryError) {
        var alertTitle: String?
        switch error {
        case .network:
            alertTitle = NSLocalizedString("delivery_list__alert_network_error", comment: "")
        case .mapping, .persist:
            alertTitle = NSLocalizedString("delivery_list__alert_error", comment: "")
        }
        let alertMessage = NSLocalizedString("delivery_list__alert_message", comment: "")
        let alertOk = NSLocalizedString("delivery_list__alert_ok", comment: "")

        let alert = UIAlertController.init(title: alertTitle,
                                           message: alertMessage,
                                           preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: alertOk, style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        if let navigation = self.navigationController as? DeliveryNavigation {
            navigation.showAlert(alert: alert)
        }
    }
}

extension DeliveryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let navigation = self.navigationController as? DeliveryNavigation,
            let deliveryId = viewModel.deliveryIdAt(index: indexPath.row) {
            navigation.showDeliveryDetail(deliveryId: deliveryId)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.fetchMoreDeliveriesIfNeeded(index: indexPath.row)
    }
}
