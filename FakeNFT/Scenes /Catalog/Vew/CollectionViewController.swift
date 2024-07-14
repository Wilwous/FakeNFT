//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Антон Павлов on 09.07.2024.
//

import UIKit

final class CollectionViewController: UIViewController, LoadingView {
    
    // MARK: - Private Properties
    
    private let viewModel: CollectionViewModel
    
    // MARK: - UI Components
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ]
        
        return image
    }()
    
    private var nameLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    private let authorLinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlue
        label.font = .systemFont(ofSize: 15,weight: .regular)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13,weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        view.dataSource = self
        view.delegate = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .ypWhite
        view.register(
            CollectionCell.self,
            forCellWithReuseIdentifier: CollectionCell.identifier
        )
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        bindViewModel()
        addElements()
        layoutConstraint()
        setUpNavigationBarBackButton()
        updateViewWithData()
        addGestureRecognizerToAuthorLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCover(urlString: viewModel.collectionInformation.cover)
    }
    
    // MARK: - Initializers
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LoadingView
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel.showLoadingHandler = { [weak self] in
            guard let self = self else { return }
            self.showLoading()
            self.view.isUserInteractionEnabled = false
        }
        
        viewModel.hideLoadingHandler = { [weak self] in
            guard let self = self else { return }
            self.hideLoading()
            self.view.isUserInteractionEnabled = true
        }
        
        viewModel.errorHandler = { [weak self] in
            guard let self = self else { return }
            self.showErrorAlert()
        }
        
        viewModel.nftsBinding = { [weak self] _ in
            guard let self = self else { return }
            self.nftCollectionView.reloadData()
        }
        
        viewModel.fetchDataToDisplay()
    }
    
    // MARK: - Alert
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Произошла ошибка сети",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
        print(
            "Network error occurred"
        )
    }
    
    //MARK: - Public Methods
    
    private func loadCover(
        urlString: String
    ) {
        if let encodingStr = urlString.addingPercentEncoding(
            withAllowedCharacters: .urlFragmentAllowed
        ) {
            if let imageUrl = URL(
                string: encodingStr
            ) {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                    with: imageUrl,
                    placeholder: UIImage(named: "Card.png")
                )
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
            }
        }
    }
    
    private func updateViewWithData() {
        nameLabel.text = viewModel.collectionInformation.name.replacingOccurrences(
            of: "\\(.*\\)",
            with: "",
            options: .regularExpression,
            range: nil
        )
        authorLinkLabel.text = viewModel.collectionInformation.author
        descriptionLabel.text = viewModel.collectionInformation.description
    }
    
    private func addGestureRecognizerToAuthorLabel() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(
                authorLinkDidTap)
        )
        authorLinkLabel.addGestureRecognizer(tap)
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [imageView,
         nameLabel,
         authorLabel,
         authorLinkLabel,
         descriptionLabel,
         nftCollectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        nftCollectionView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutConstraint() {
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor.constraint(
                    equalTo: nftCollectionView.centerXAnchor
                ),
                
                activityIndicator.centerYAnchor.constraint(
                    equalTo: nftCollectionView.centerYAnchor
                ),
                
                imageView.topAnchor.constraint(
                    equalTo: view.topAnchor
                ),
                
                imageView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ),
                
                imageView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor
                ),
                
                imageView.heightAnchor.constraint(
                    equalToConstant: 310
                ),
                
                nameLabel.topAnchor.constraint(
                    equalTo: imageView.bottomAnchor,
                    constant: 16
                ),
                
                nameLabel.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: 16
                ),
                
                nameLabel.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor,
                    constant: -16
                ),
                
                nameLabel.heightAnchor.constraint(
                    equalToConstant: 28
                ),
                
                authorLabel.topAnchor.constraint(
                    equalTo: nameLabel.bottomAnchor,
                    constant: 8
                ),
                
                authorLabel.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: 16
                ),
                
                authorLabel.heightAnchor.constraint(
                    equalToConstant: 28
                ),
                
                authorLinkLabel.topAnchor.constraint(
                    equalTo: authorLabel.topAnchor
                ),
                
                authorLinkLabel.leadingAnchor.constraint(
                    equalTo: authorLabel.trailingAnchor,
                    constant: 4
                ),
                
                authorLinkLabel.heightAnchor.constraint(
                    equalToConstant: 28
                ),
                
                descriptionLabel.topAnchor.constraint(
                    equalTo: authorLabel.bottomAnchor
                ),
                
                descriptionLabel.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: 16
                ),
                
                descriptionLabel.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor,
                    constant: -16
                ),
                
                nftCollectionView.topAnchor.constraint(
                    equalTo: descriptionLabel.bottomAnchor,
                    constant: 24
                ),
                
                nftCollectionView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor
                ),
                
                nftCollectionView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor
                ),
                
                nftCollectionView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor
                )
            ]
        )
    }
    
    private func setUpNavigationBarBackButton() {
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: " ",
            style: .plain,
            target: nil,
            action: nil
        )
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .ypBlack
    }
    
    // MARK: - Action
    
    @objc func authorLinkDidTap() {
        let vc = AuthorWebViewController(websiteLinkString: viewModel.websiteLink)
        self.navigationController?.pushViewController(vc,animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.nfts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCell.identifier,
            for: indexPath
        ) as? CollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        cell.configure(with: viewModel.nfts[indexPath.row])
        
        cell.didLikeTappedHandler = { [weak self] nftId in
            self?.viewModel.didLikeButtonTapped(nftId: nftId) { isLiked in
                cell.updateLikeButton(isLiked: isLiked)
                collectionView.reloadItems(at: [indexPath])
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - 2 *
        Constants.minimumInteritemSpacing - 2 * Constants.leftRightInsets
        let cellWidth =  availableWidth / 3
        
        let cellHeight = cellWidth + Constants.spaceBetweenCoverAndInfo + Constants.infoHeight
        return CGSize(
            width: cellWidth,
            height: cellHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.minimumInteritemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.minimumLineSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let id = viewModel.nfts[indexPath.row].id
        let presenter = NftDetailPresenterImpl(
            input: NftDetailInput(id: id),
            service: NftServiceImpl(
                networkClient: DefaultNetworkClient(),
                storage: NftStorageImpl()
            )
        )
        
        let vc = NftDetailViewController(presenter: presenter)
        presenter.view = vc
        present(vc, animated: true)
    }
}
