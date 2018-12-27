//
//  DeliveryListView.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

/*
 * Containts:
 * 1. Header View:
 *   - title label
 *   - refresh button
 * 2. UITableView
 * 3. Centered ActivityIndicatorView
 */
class DeliveryListView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56.0

        tableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: DeliveryTableViewCell.cellIdentifier)
        return tableView
    }()

    lazy var refreshButton: UIButton = {
        let refreshButton = UIButton.init(type: .system)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setTitle(NSLocalizedString("delivery_list__refresh", comment: ""), for: .normal)
        refreshButton.setContentHuggingPriority(.required, for: .horizontal)
        return refreshButton
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        return activityIndicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViews()
    }

    private func createViews() {
        // Blurred background
        self.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurView)
        self.addConstraints([
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leftAnchor.constraint(equalTo: self.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: self.rightAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])

        let container = blurView.contentView
        let header = createHeaderView()

        container.addSubview(header)
        container.addSubview(self.tableView)
        container.addConstraints([
            header.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
            header.leftAnchor.constraint(equalTo: container.leftAnchor),
            header.rightAnchor.constraint(equalTo: container.rightAnchor),
            header.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: container.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: container.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])

        container.addSubview(activityIndicator)
        container.addConstraints([
            activityIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
    }

    private func createHeaderView() -> UIView {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel.init()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = NSLocalizedString("delivery_list__title", comment: "")
        title.font = UIFont.preferredFont(forTextStyle: .title1)
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)

        header.addSubview(title)
        header.addSubview(refreshButton)

        let labelTop = title.topAnchor.constraint(equalTo: header.topAnchor, constant: 8)
        let labelBottom = title.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
        let labelLeft = title.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20)

        let buttonTop = refreshButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 8)
        let buttonBottom = refreshButton.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
        let buttonRight = refreshButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -20)

        let buttonLeftLabelRight = title.rightAnchor.constraint(equalTo: refreshButton.leftAnchor, constant: -8)

        labelBottom.priority = .defaultHigh
        buttonBottom.priority = .defaultHigh
        buttonRight.priority = .defaultHigh

        header.addConstraints([labelTop, labelBottom, labelLeft,
                               buttonTop, buttonBottom, buttonRight, buttonLeftLabelRight])
        return header
    }
}
