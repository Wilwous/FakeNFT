//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Combine
import Kingfisher
import UIKit

final class CurrencyCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.ypBlackDay.cgColor : UIColor.clear.cgColor
        }
    }
    
    // MARK: - UI Components
    
    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cripto_bitcoin")
        imageView.backgroundColor = .ypBlack
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypBlackDay
        label.text = "Bitcoin"
        return label
    }()
    
    private let shortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypGreen
        label.text = "BTC"
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                fullNameLabel,
                shortNameLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                currencyImageView,
                verticalStackView
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: CurrencyCellViewModel) {
        bindViewModel(viewModel)
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel(_ viewModel: CurrencyCellViewModel) {
        viewModel.$viewData
            .receive(on: RunLoop.main)
            .sink { [weak self] viewData in
                self?.fullNameLabel.text = viewData.title
                self?.shortNameLabel.text = viewData.name
                guard let self = self, let url = URL(string: viewData.imageURLString) else { return }
                self.loadImage(url: url)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(mainStackView)
        
        [
            currencyImageView,
            fullNameLabel,
            shortNameLabel,
            verticalStackView,
            mainStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.backgroundColor = .ypLightGrayDay
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            fullNameLabel.heightAnchor.constraint(equalToConstant: 18),
            shortNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupSelection() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 12
    }
    
    private func loadImage(url: URL) {
        currencyImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 6)
        currencyImageView.kf.setImage(
            with: url,
            placeholder: .none,
            options: [.processor(processor)]
        )
    }
}

