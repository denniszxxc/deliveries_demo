//
//  SelectedDeliveryListViewController.swift
//  deliveries
//
//  Created by Dennis Li on 28/12/2018.
//  Copyright © 2018年 Dennis Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectedDeliveryListViewController: UIViewController {
    var selectedDeliveryIds: [Int]!
    var viewModel: SelectedDeliveryListViewModel!
    var disposeBag = DisposeBag()

    weak var tableView: UITableView!
    weak var titleLabel: UILabel!

    override func loadView() {
        let view = DeliveryListView()
        view.tableView.delegate = self
        view.refreshButton.isHidden = true

        self.view = view
        self.tableView = view.tableView
        self.titleLabel = view.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SelectedDeliveryListViewModel(selectedDeliveresId: selectedDeliveryIds)

        viewModel.deliveryObservable?
            .bind(to:
                tableView.rx.items(cellIdentifier: DeliveryTableViewCell.cellIdentifier,
                                   cellType: DeliveryTableViewCell.self)) { (_, element, cell) in
                                    cell.bind(delivery: element)}
            .disposed(by: disposeBag)

        let titleFormat = NSLocalizedString("selected_delivery_list__title", comment: "")
        viewModel.deliveryCountObservable?
            .map({ String.init(format: titleFormat, $0) })
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension SelectedDeliveryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let navigation = self.navigationController as? DeliveryNavigation,
            let deliveryId = viewModel.deliveryIdAt(index: indexPath.row) {
            navigation.showDeliveryDetail(deliveryId: deliveryId)
        }
    }
}
