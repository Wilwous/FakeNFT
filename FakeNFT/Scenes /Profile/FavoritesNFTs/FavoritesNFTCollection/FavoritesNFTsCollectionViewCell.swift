//
//  FavoritesNFTsCollectionViewCell.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 02.07.2024.
//

import UIKit

protocol FavoritesNFTsCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(in cell: FavoritesNFTsCollectionViewCell)
}

final class FavoritesNFTsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoritesNFTsCollectionViewCell"

    weak var delegate: FavoritesNFTsCollectionViewCellDelegate?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like_active")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(likeImageView)
        contentView.addSubview(verticalStackView)

        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(ratingImageView)
        verticalStackView.addArrangedSubview(priceLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeImageView.addGestureRecognizer(tapGesture)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func likeTapped() {
        delegate?.didTapLikeButton(in: self)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            likeImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 6),
            likeImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -6),
            likeImageView.widthAnchor.constraint(equalToConstant: 42),
            likeImageView.heightAnchor.constraint(equalToConstant: 42),

            verticalStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            verticalStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    func configure(with item: NFTItem) {
        imageView.image = UIImage(named: item.imageName)
        nameLabel.text = item.name
        ratingImageView.image = UIImage(named: item.ratingImageName)
        priceLabel.text = item.price
    }
}
