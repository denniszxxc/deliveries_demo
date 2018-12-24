//
//  DeliveryListViewController
//  deliveries
//
//  Created by Dennis Li on 20/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

class DeliveryListViewController: UIViewController {
    override func loadView() {
        let view = DeliveryListView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DeliveryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: change tableview's data
        return 5
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
