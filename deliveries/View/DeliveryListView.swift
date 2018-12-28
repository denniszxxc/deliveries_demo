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

    lazy var centeredOverlayActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = false
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
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
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
            header.topAnchor.constraint(equalTo: container.topAnchor),
            header.leftAnchor.constraint(equalTo: container.leftAnchor),
            header.rightAnchor.constraint(equalTo: container.rightAnchor),
            header.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: container.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: container.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])

        container.addSubview(centeredOverlayActivityIndicator)
        container.addConstraints([
            centeredOverlayActivityIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            NSLayoutConstraint.init(item: centeredOverlayActivityIndicator, attribute: .centerY, relatedBy: .equal,
                                    toItem: container, attribute: .centerY, multiplier: 0.5, constant: 0)
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

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray

        header.addSubview(title)
        header.addSubview(refreshButton)
        header.addSubview(separator)

        let labelTop = title.topAnchor.constraint(equalTo: header.topAnchor, constant: 16)
        let labelBottom = title.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16)
        let labelLeft = title.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20)

        let buttonTop = refreshButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 16)
        let buttonBottom = refreshButton.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16)
        let buttonRight = refreshButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -20)

        let buttonLeftLabelRight = title.rightAnchor.constraint(equalTo: refreshButton.leftAnchor, constant: -8)

        labelBottom.priority = .defaultHigh
        buttonBottom.priority = .defaultHigh
        buttonRight.priority = .defaultHigh

        let separatorBottom = separator.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        let separatorLeft = separator.leftAnchor.constraint(equalTo: header.leftAnchor)
        let separatorRight = separator.rightAnchor.constraint(equalTo: header.rightAnchor)
        let separatorHeight = separator.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale)

        header.addConstraints([labelTop, labelBottom, labelLeft,
                               buttonTop, buttonBottom, buttonRight, buttonLeftLabelRight,
                               separatorBottom, separatorLeft, separatorRight, separatorHeight
            ])
        return header
    }

    private func tableViewFooter() -> UIView {
        // Cannot use autolayout on UITableView's tableFooterView
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 90))

        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()

        footerView.addSubview(activityIndicator)
        activityIndicator.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin,
                                              .flexibleLeftMargin, .flexibleRightMargin]
        activityIndicator.center = CGPoint(x: footerView.bounds.midX,
                                           y: footerView.bounds.midY)
        return footerView
    }

    public func showTableViewLoadingFooterView() {
        tableView.tableFooterView = tableViewFooter()
    }

    public func hidebleViewLoadingFooterView() {
        tableView.tableFooterView = nil
    }
}
