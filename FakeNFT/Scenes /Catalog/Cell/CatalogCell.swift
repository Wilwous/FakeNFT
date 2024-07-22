//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "CatalogCell"
    static let height: CGFloat = 187
    
    // MARK: - UI Components
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    private lazy var catalogImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .ypGray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        
        return image
    }()
    
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .ypBlack
        
        return label
    }()
    
    // MARK: - Initializers
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        self.backgroundColor = .ypWhite
        self.selectionStyle = .none
        addElements()
        layoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        catalogImage.kf.cancelDownloadTask()
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Public Methods
    
    func configure(
        with viewModel: NFTViewModel
    ) {
        catalogLabel.text = viewModel.name
        loadImage(
            from: viewModel.coverURL
        )
    }
    
    // MARK: - Private Methods
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            catalogImage.image = UIImage(named: "placeholder")
            return
        }
        activityIndicator.startAnimating()
        catalogImage.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if case .failure = result {
                    self.catalogImage.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [activityIndicator,
         catalogLabel,
         catalogImage
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func layoutConstraint() {
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor.constraint(
                    equalTo: catalogImage.centerXAnchor
                ),
                
                activityIndicator.centerYAnchor.constraint(
                    equalTo: catalogImage.centerYAnchor
                ),
                
                catalogImage.topAnchor.constraint(
                    equalTo: contentView.topAnchor
                ),
                catalogImage.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor
                ),
                catalogImage.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor
                ),
                catalogImage.heightAnchor.constraint(
                    equalToConstant: 140
                ),
                
                catalogLabel.topAnchor.constraint(
                    equalTo: catalogImage.bottomAnchor,
                    constant: 4
                ),
                catalogLabel.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor
                )
            ]
        )
    }
}
