//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "CatalogCell"
    
    // MARK: - UI Components
    
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
        addElements()
        layoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        catalogImage.kf.cancelDownloadTask()
    }
    
    func configure(with viewModel: CollectionViewModel) {
        catalogLabel.text = viewModel.name
        loadImage(from: viewModel.coverURL)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            catalogImage.image = UIImage(named: "placeholder")
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.catalogImage.image = UIImage(named: "placeholder")
                }
                return
            }
            DispatchQueue.main.async {
                self.catalogImage.image = image
            }
        }.resume()
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [catalogLabel,
         catalogImage
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func layoutConstraint() {
        NSLayoutConstraint.activate(
            [
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
