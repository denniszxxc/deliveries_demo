//
//  DeliveryDetailView.swift
//  deliveries
//
//  Created by Dennis Li on 27/12/2018.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

class DeliveryDetailView: UIView {

    lazy var dismissButton: UIButton = {
        let dismissButton = UIButton.init(type: .system)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        let imagePadding: CGFloat = 12.0
        dismissButton.imageEdgeInsets = UIEdgeInsets.init(top: imagePadding, left: imagePadding,
                                                          bottom: imagePadding, right: imagePadding)
        dismissButton.setImage(UIImage.init(named: "ic_dismiss"), for: .normal)
        dismissButton.tintColor = UIColor.gray
        return dismissButton
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return titleLabel
    }()

    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return subtitleLabel
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

        container.addSubview(dismissButton)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)

        let containerPadding: CGFloat = 16
        container.addConstraints([
            dismissButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            dismissButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10),
            dismissButton.widthAnchor.constraint(equalToConstant: 48),
            dismissButton.heightAnchor.constraint(equalToConstant: 48),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: containerPadding),
            titleLabel.rightAnchor.constraint(equalTo: dismissButton.leftAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: containerPadding),
            subtitleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -containerPadding)
        ])
    }
}
