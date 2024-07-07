//
//  FavoritesNFTsViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

// FavoritesNFTsViewController.swift
import UIKit

final class FavoritesNFTsViewController: UIViewController, FavoritesNFTsCollectionViewDelegate {

    // MARK: - Properties
    private let noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
        label.font = .bodyBold
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: FavoritesNFTsCollectionView = {
        let items = FavoritesNFTMockData.items
        let collectionView = FavoritesNFTsCollectionView(items: items)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.itemsDelegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        updateUI()
        view.backgroundColor = .ypWhiteDay

    }

    // MARK: - Setup Navigation Bar

    private func setupNavigationBar() {
        navigationItem.title = "Избранные NFT"

        let leftButton = UIImage(named: "backward")?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: leftButton,
            style: .plain,
            target: self,
            action: #selector(leftButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackDay
        
    }

    private func leftToRightTransition() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
    }

    @objc private func leftButtonTapped() {
        leftToRightTransition()
        dismiss(animated: false, completion: nil)
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(noNFTLabel)
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func updateUI() {
        let items = collectionView.getItems()
        if items.isEmpty {
            collectionView.isHidden = true
            noNFTLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            noNFTLabel.isHidden = true
        }
    }

    func didUpdateItems(_ items: [NFTItem]) {
        updateUI()
    }
}
