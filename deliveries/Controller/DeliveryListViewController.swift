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
        view.tableView.prefetchDataSource = self
        view.refreshButton.addTarget(self, action: #selector(didClickRefresh), for: .touchUpInside)

        self.view = view
        self.tableView = view.tableView
        self.activityIndicator = view.activityIndicator
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.refreshDeliveries()

        viewModel.deliveryRepository
            .deliveryObservable()?
            .bind(to:
                tableView.rx.items(cellIdentifier: DeliveryTableViewCell.cellIdentifier,
                                   cellType: DeliveryTableViewCell.self)) { (_, element, cell) in
                                    cell.bind(delivery: element)}
            .disposed(by: disposeBag)

        viewModel.loading
            .map({ !$0 })
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.fetchDeliveriesError
            .subscribe(onNext: { [weak self] error in
                guard let error = error else {
                    return
                }
                self?.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }

    @objc func didClickRefresh(_: UIButton) {
        viewModel.refreshDeliveries()
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
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension DeliveryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: navigate to detail page
        print("didSlectRowAt \(indexPath.row)")
    }
}

extension DeliveryListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.fetchMoreDeliveriesIfNeeded(indices: indexPaths.map({ $0.row }))
    }
}
