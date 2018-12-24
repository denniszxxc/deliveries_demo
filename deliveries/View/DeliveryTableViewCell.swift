//
//  DeliveryTableViewCell.swift
//  deliveries
//
//  Created by Dennis Li on 24/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

class DeliveryTableViewCell: UITableViewCell {
    static let cellIdentifier = "DeliveryTableViewCell"

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        return titleLabel
    }()

    private lazy var thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView()
        thumbnailImageView.backgroundColor = UIColor.lightGray
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        thumbnailImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        thumbnailImageView.setContentCompressionResistancePriority(.required, for: .vertical)
        thumbnailImageView.contentMode = .scaleAspectFit
        return thumbnailImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViews()
    }

    private func createViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(thumbnailImageView)

        self.contentView.addConstraints([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: self.thumbnailImageView.leftAnchor, constant: -8),

            thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 64),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 64),
            thumbnailImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20)
            ])
    }

}
