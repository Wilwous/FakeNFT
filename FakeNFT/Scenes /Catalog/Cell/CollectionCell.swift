//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Антон Павлов on 11.07.2024.
//

import UIKit
import Kingfisher

final class CollectionCell: UICollectionViewCell {
    
    // MARK: - Сlosure
    
    var didLikeTappedHandler: ((String) -> ())?
    var didCartTappedHandler: ((String) -> ())?
    
    // MARK: - Static Properties
    
    static let identifier = "CollectionCell"
    
    // MARK: - Private Properties
    
    private var nftId: String?
    
    // MARK: - UI Components
    
    private lazy var nftImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        
        return image
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "like_no_active"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didLikeButtonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var starsImages: [UIImageView] = {
        var stars: [UIImageView] = []
        for i in 1...5 {
            if let starImage = UIImage(named: "star_no_active") {
                stars.append(UIImageView(image: starImage))
            }
        }
        
        return stars
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .medium)
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "item_add"),for: .normal)
        button.addTarget(
            self,
            action: #selector(didCartButtonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        
        return stack
    }()
    
    //MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .ypWhite
        addElements()
        layoutConstraint()
        setUpStarsStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Publice Methods
    
    func configure(with model: NftCellModel) {
        loadImage(urlString: model.cover)
        nameLabel.text = model.name
        priceLabel.text = "\(model.price) ETH"
        updateRating(rating: model.stars)
        updateCartButton(isInCart: model.isInCart)
        updateLikeButton(isLiked: model.isLiked)
        nftId = model.id
    }
    
    func updateLikeButton(isLiked: Bool) {
        let imageName = isLiked ? "like_active" : "like_no_active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func updateCartButton(isInCart: Bool) {
        let imageName = isInCart ? "item_delete" : "item_add"
        cartButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // MARK: Private Methods
    
    private func loadImage(
        urlString: String
    ) {
        if let encodingStr = urlString.addingPercentEncoding(
            withAllowedCharacters: .urlFragmentAllowed
        )  {
            if let imageUrl = URL(
                string: encodingStr
            ) {
                nftImageView.kf.indicatorType = .activity
                nftImageView.kf.setImage(
                    with: imageUrl,
                    placeholder: UIImage(named: "Card.png")
                )
                nftImageView.contentMode = .scaleAspectFill
                nftImageView.layer.cornerRadius = 16
                nftImageView.layer.masksToBounds = false
                nftImageView.clipsToBounds = true
            }
        }
    }
    
    private func updateRating(rating: Int) {
        for i in 0..<rating {
            if let starImage = UIImage(named: "star_active") {
                starsImages[i].image = starImage
            }
        }
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [nftImageView,
         likeButton,
         nameLabel,
         priceLabel,
         cartButton,
         starsStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func layoutConstraint() {
        NSLayoutConstraint.activate(
            [
                nftImageView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor
                ),
                
                nftImageView.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor
                ),
                
                nftImageView.topAnchor.constraint(
                    equalTo: contentView.topAnchor
                ),
                
                nftImageView.heightAnchor.constraint(
                    equalTo: nftImageView.widthAnchor,
                    multiplier: 1.0/1.0
                ),
                
                likeButton.heightAnchor.constraint(
                    equalToConstant: 40
                ),
                
                likeButton.widthAnchor.constraint(
                    equalToConstant: 40
                ),
                
                likeButton.topAnchor.constraint(
                    equalTo: contentView.topAnchor
                ),
                
                likeButton.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor
                ),
                
                nameLabel.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor
                ),
                
                nameLabel.topAnchor.constraint(
                    equalTo: starsStackView.bottomAnchor,
                    constant: 5
                ),
                
                nameLabel.heightAnchor.constraint(
                    equalToConstant: 22
                ),
                
                nameLabel.trailingAnchor.constraint(
                    equalTo: cartButton.leadingAnchor
                ),
                
                priceLabel.heightAnchor.constraint(
                    equalToConstant: 12
                ),
                
                priceLabel.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor
                ),
                
                priceLabel.topAnchor.constraint(
                    equalTo: nameLabel.bottomAnchor,
                    constant: 4
                ),
                
                priceLabel.trailingAnchor.constraint(
                    equalTo: cartButton.leadingAnchor
                ),
                
                cartButton.heightAnchor.constraint(
                    equalToConstant: 40
                ),
                
                cartButton.widthAnchor.constraint(
                    equalToConstant: 40
                ),
                
                cartButton.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor
                ),
                
                cartButton.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor
                ),
                
                starsStackView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor
                ),
                
                starsStackView.topAnchor.constraint(
                    equalTo: nftImageView.bottomAnchor,
                    constant: 8
                ),
                
                starsStackView.widthAnchor.constraint(
                    equalToConstant: 68
                ),
                
                starsStackView.heightAnchor.constraint(
                    equalToConstant: 12
                )
            ]
        )
    }
    
    private func setUpStarsStackView() {
        starsStackView.axis = .horizontal
        starsStackView.spacing = 2
        starsImages.forEach { starImageView in
            starsStackView.addArrangedSubview(
                starImageView
            )
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                [
                    starImageView.widthAnchor.constraint(
                        equalToConstant: 12
                    ),
                    starImageView.heightAnchor.constraint(
                        equalToConstant: 12
                    )
                ]
            )
        }
    }
    
    //MARK: - Action
    
    @objc func didLikeButtonTapped() {
        guard let nftId = nftId else { return }
        didLikeTappedHandler?(nftId)
    }
    
    @objc func didCartButtonTapped() {
        guard let nftId = nftId else { return }
        didCartTappedHandler?(nftId)
    }
}

