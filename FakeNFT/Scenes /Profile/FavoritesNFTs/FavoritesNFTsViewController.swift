//
//  FavoritesNFTsViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import Combine
import Kingfisher
import UIKit
import ProgressHUD

final class FavoritesNFTsViewController: UIViewController, FavoritesNFTsCollectionViewDelegate {
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var nfts: [Nft] = []
    private let unifiedService: NftServiceCombine
    private let refreshControl = UIRefreshControl()
    
    // MARK: - UI Components
    
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
        let items = [Nft]()
        let collectionView = FavoritesNFTsCollectionView(items: items)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.itemsDelegate = self
        return collectionView
    }()
    
    // MARK: - Initializer
    
    init(unifiedService: NftServiceCombine) {
        self.unifiedService = unifiedService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupRefreshControl()
        view.backgroundColor = .ypWhiteDay
        loadFavoriteNFTs(forProfileId: "1")
    }
    
    // MARK: - Public Methods
    
    func didTapLikeButton(in cell: FavoritesNFTsCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = nfts[indexPath.row]
        
        let userDefaults = UserDefaults.standard
        var favoriteNFTs = userDefaults.array(forKey: "FavoriteNFTs") as? [String] ?? []
        
        if let index = favoriteNFTs.firstIndex(of: nft.id) {
            favoriteNFTs.remove(at: index)
        } else {
            favoriteNFTs.append(nft.id)
        }
        
        userDefaults.set(favoriteNFTs, forKey: "FavoriteNFTs")
        nfts.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: nft.id)
        
        updateProfileLikes(profileId: "1", likes: favoriteNFTs)
    }
    
    func didUpdateItems(_ items: [Nft]) {
        nfts = items
        collectionView.updateItems(items)
        updateUI()
        
        let updatedLikes = items.map { $0.id }
        UserDefaults.standard.set(updatedLikes, forKey: "FavoriteNFTs")
        UserDefaults.standard.synchronize()
    }
    
    func updateProfileLikes(profileId: String = "1", likes: [String]) {
        ProgressHUD.show()
        let params = UpdateProfileParams(likes: likes)
        unifiedService.updateProfile(params: params)
            .sink(receiveCompletion: { completion in
                ProgressHUD.dismiss()
                switch completion {
                case .finished:
                    print("✅ Лайки успешно обновлены")
                case .failure(let error):
                    print("⛔️ Ошибка при обновлении лайков: \(error)")
                }
            }, receiveValue: { [weak self] updatedProfile in
                print("✅ Обновленный профиль: \(updatedProfile)")
                self?.loadFavoriteNFTs(forProfileId: profileId)
            })
            .store(in: &cancellables)
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
    
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshFavoriteNFTs), for: .valueChanged)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(noNFTLabel)
        noNFTLabel.isHidden = true
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
        if nfts.isEmpty {
            collectionView.isHidden = true
            noNFTLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            noNFTLabel.isHidden = true
        }
    }
    
    // MARK: - Action
    
    @objc private func leftButtonTapped() {
        leftToRightTransition()
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func refreshFavoriteNFTs() {
        loadFavoriteNFTs(forProfileId: "1") {
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Load Favorite NFTs

extension FavoritesNFTsViewController {
    private func loadFavoriteNFTs(forProfileId profileId: String, completion: (() -> Void)? = nil) {
        ProgressHUD.show()
        
        unifiedService.loadFavoriteNfts(profileId: profileId)
            .sink(receiveCompletion: { [weak self] completionResult in
                ProgressHUD.dismiss()
                completion?()
                switch completionResult {
                case .finished:
                    print("✅ Загрузка избранных NFT завершена успешно")
                case .failure(let error):
                    print("⛔️ Ошибка загрузки избранных NFT: \(error)")
                    self?.updateUI()
                }
            }, receiveValue: { [weak self] nfts in
                print("✅ Полученные данные избранных NFT: \(nfts)")
                self?.nfts = nfts
                self?.collectionView.updateItems(nfts)
                self?.updateUI()
            })
            .store(in: &cancellables)
    }
}
