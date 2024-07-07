//
//  UsersNFTsTableViewCell.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import UIKit

final class UsersNFTsTableViewCell: UITableViewCell {

    static let identifier = "UsersNFTsTableViewCell"
    private var isLiked = false

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "like_no_active")
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Цена"
        label.textAlignment = .left
        return label
    }()

    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeImageView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func likeTapped() {
        isLiked.toggle()
        likeImageView.image = isLiked ? UIImage(named: "like_active") : UIImage(named: "like_no_active")
        print("Лайк \(isLiked ? "поставлен" : "отменён")")
    }

    private func setupUI() {
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(ratingImageView)
        infoStackView.addArrangedSubview(authorLabel)

        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)

        contentView.addSubview(nftImageView)
        contentView.addSubview(likeImageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(priceStackView)
    }

    private func setupConstraints() {
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImageView.widthAnchor.constraint(equalToConstant: 40),
            likeImageView.heightAnchor.constraint(equalToConstant: 40),

            infoStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: priceStackView.leadingAnchor, constant: -16),

            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceStackView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    func configure(
        with nft: (
            image: UIImage?,
            title: String,
            rating: UIImage?,
            author: String,
            priceValue: String
        )
    ) {
        nftImageView.image = nft.image
        titleLabel.text = nft.title
        ratingImageView.image = nft.rating
        authorLabel.text = "от \(nft.author)"
        priceValueLabel.text = nft.priceValue

        isLiked = false 
        likeImageView.image = UIImage(named: "like_no_active")
    }
}
