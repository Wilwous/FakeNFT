//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 22.06.2024.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "ProfileTableViewCell"

    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.isHidden = true
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let iconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .ypBlackDay
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setCellConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setCellConstraints() {
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainTextLabel)
        contentView.addSubview(secondaryTextLabel)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            mainTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            secondaryTextLabel.leadingAnchor.constraint(equalTo: mainTextLabel.trailingAnchor, constant: 8),
            secondaryTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            iconContainer.leadingAnchor.constraint(equalTo: secondaryTextLabel.trailingAnchor, constant: 8),
            iconContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.heightAnchor.constraint(equalToConstant: 22),
            iconContainer.widthAnchor.constraint(equalToConstant: 16),

            iconImageView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            iconImageView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    func configure(mainText: String, secondaryText: String?, icon: UIImage) {
        mainTextLabel.text = mainText
        if let secondaryText = secondaryText {
            secondaryTextLabel.text = secondaryText
            secondaryTextLabel.isHidden = false
        } else {
            secondaryTextLabel.isHidden = true
        }
        iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
    }
}
