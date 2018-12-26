//
//  DeliveryListViewController
//  deliveries
//
//  Created by Dennis Li on 20/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

class DeliveryListViewController: UIViewController {
    var viewModel = DeliveryListViewModel()

    override func loadView() {
        let view = DeliveryListView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.refreshButton.addTarget(self, action: #selector(didClickRefresh), for: .touchUpInside)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fechDeliveries()
    }

    @objc func didClickRefresh(_: UIButton) {
        viewModel.refreshDeliveries()
    }
}

extension DeliveryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: change tableview's data
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryTableViewCell.cellIdentifier, for: indexPath)
        // TODO: bind data
        return cell
    }
}

extension DeliveryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: bind data
        print("didSlectRowAt \(indexPath.row)")
    }
}
