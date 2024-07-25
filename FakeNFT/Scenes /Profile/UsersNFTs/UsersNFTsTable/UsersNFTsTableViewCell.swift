//
//  UsersNFTsTableViewCell.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import Kingfisher
import UIKit
import Combine

protocol UsersNFTsTableViewCellDelegate: AnyObject {
    func didTapLikeButton(nft: Nft, isLiked: Bool)
}

final class UsersNFTsTableViewCell: UITableViewCell {
    
    //MARK: - Static
    
    static let identifier = "UsersNFTsTableViewCell"
    
    //MARK: - Delegate
    
    weak var delegate: UsersNFTsTableViewCellDelegate?
    
    // MARK: - Public Properties
    
    var isLiked = false
    var nft: Nft!
    
    // MARK: - UI Components
    
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
    
    private let ratingView: RatingView = {
        let ratingView = RatingView(frame: .zero, viewModel: RatingViewModel())
        return ratingView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
    
    // MARK: - Initializer
    
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
    
    //MARK: - Public Methods
    
    func configure(with nft: Nft) {
        self.nft = nft
        if let url = nft.images.first {
            nftImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            nftImageView.image = UIImage(named: "placeholder")
        }
        titleLabel.text = nft.name
        ratingView.viewModel.setRating(nft.rating)
        authorLabelFormatter(author: nft.author)
        priceValueLabel.text = "\(nft.price) ETH"
        
        let userDefaults = UserDefaults.standard
        let favoriteNFTs = userDefaults.array(forKey: "FavoriteNFTs") as? [String] ?? []
        isLiked = favoriteNFTs.contains(nft.id)
        likeImageView.image = isLiked ? UIImage(named: "like_active") : UIImage(named: "like_no_active")
    }
    
    //MARK: - Private Methods
    
    private func setupUI() {
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(ratingView)
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
    
    private func authorLabelFormatter(author: String) {
        var authorUrl = author
        authorUrl = authorUrl.replacingOccurrences(of: "https://", with: "")
        if authorUrl.hasSuffix("/") {
            authorUrl = String(authorUrl.dropLast())
        }
        
        let fullText = "от \(authorUrl)"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        
        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        let nonBreakingSpaceRange = (fullText as NSString).range(of: "от ")
        if nonBreakingSpaceRange.location != NSNotFound {
            attributedString.replaceCharacters(in: NSRange(location: nonBreakingSpaceRange.location + nonBreakingSpaceRange.length - 1, length: 1), with: NSAttributedString(string: "\u{00A0}"))
        }
        authorLabel.attributedText = attributedString
    }
    
    // MARK: - Action
    
    @objc func likeTapped() {
        isLiked.toggle()
        likeImageView.image = isLiked ? UIImage(named: "like_active") : UIImage(named: "like_no_active")
        
        let userDefaults = UserDefaults.standard
        var favoriteNFTs = userDefaults.array(forKey: "FavoriteNFTs") as? [String] ?? []
        if isLiked {
            favoriteNFTs.append(nft.id)
        } else {
            favoriteNFTs.removeAll { $0 == nft.id }
        }
        
        userDefaults.set(favoriteNFTs, forKey: "FavoriteNFTs")
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: nft.id)
        
        delegate?.didTapLikeButton(nft: nft, isLiked: isLiked)
    }
}

// MARK: - Notification Name Extension

extension Notification.Name {
    static let favoriteStatusChanged = Notification.Name("favoriteStatusChanged")
}
