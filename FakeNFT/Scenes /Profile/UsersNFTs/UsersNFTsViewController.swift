//
//  UsersNFTsViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import Combine
import UIKit
import ProgressHUD

final class UsersNFTsViewController: UIViewController, UsersNFTsTableViewCellDelegate {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let nftService: NftServiceCombine
    private let refreshControl = UIRefreshControl()
    private var dimmingView: UIView?
    private let sortingMethodKey = "sortingMethod"
    
    private let noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет NFT"
        label.font = .bodyBold
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var nftsTableView: UsersNTFsTableView = {
        let tableView = UsersNTFsTableView()
        tableView.likeDelegate = self
        return tableView
    }()
    
    // MARK: - Initializer
    
    init(nftService: NftServiceCombine) {
        self.nftService = nftService
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
        loadUsersNFTs(forProfileId: "1")
        setupBindings()
        applySavedSortingMethod()
    }
    
    // MARK: - Setup Navigation Bar
    
    private func setupNavigationBar() {
        navigationItem.title = "Мои NFT"
        
        let leftButton = UIImage(named: "backward")?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: leftButton,
            style: .plain,
            target: self,
            action: #selector(leftButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackDay
        
        let rightButton = UIImage(named: "sort")?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightButton,
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .ypBlackDay
    }
    
    private func leftToRightTransition() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    private func setupBindings() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteStatusChanged(_:)),
            name: .favoriteStatusChanged,
            object: nil)
    }
    
    private func enableRightButton(_ enable: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enable
    }
    
    private func saveSortingMethod(method: String) {
        UserDefaults.standard.set(method, forKey: sortingMethodKey)
        UserDefaults.standard.synchronize()
    }
    
    private func loadSortingMethod() -> String? {
        return UserDefaults.standard.string(forKey: sortingMethodKey)
    }
    
    private func sortNFTsBy() {
        setupDimmingView()
        let actionSheet = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.nftsTableView.nfts.sort(by: { $0.price < $1.price })
            self?.nftsTableView.reloadData()
            self?.saveSortingMethod(method: "price")
            self?.removeDimmingView()
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.nftsTableView.nfts.sort(by: { $0.rating > $1.rating })
            self?.nftsTableView.reloadData()
            self?.saveSortingMethod(method: "rating")
            self?.removeDimmingView()
        }
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.nftsTableView.nfts.sort(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
            self?.nftsTableView.reloadData()
            self?.saveSortingMethod(method: "name")
            self?.removeDimmingView()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { [weak self] _ in
            self?.removeDimmingView()
        }
        
        actionSheet.addAction(sortByPriceAction)
        actionSheet.addAction(sortByRatingAction)
        actionSheet.addAction(sortByNameAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func applySavedSortingMethod() {
        let method = loadSortingMethod() ?? "rating"
        switch method {
        case "price":
            nftsTableView.nfts.sort(by: { $0.price < $1.price })
        case "rating":
            nftsTableView.nfts.sort(by: { $0.rating > $1.rating })
        case "name":
            nftsTableView.nfts.sort(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
        default:
            nftsTableView.nfts.sort(by: { $0.rating > $1.rating })
        }
        nftsTableView.reloadData()
    }
    
    private func setupDimmingView() {
        let dimView = UIView(frame: view.bounds)
        dimView.backgroundColor = UIColor.ypBackground
        dimView.isUserInteractionEnabled = false
        view.addSubview(dimView)
        dimmingView = dimView
    }
    
    private func removeDimmingView() {
        dimmingView?.removeFromSuperview()
        dimmingView = nil
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .ypWhiteDay
        view.addSubview(noNFTLabel)
        view.addSubview(nftsTableView)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        noNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        nftsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nftsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            nftsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Refresh Control
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshNFTs), for: .valueChanged)
        nftsTableView.addSubview(refreshControl)
    }
    
    // MARK: - UsersNFTsTableViewCellDelegate
    
    func didTapLikeButton(nft: Nft, isLiked: Bool) {
        var favoriteNFTs: [String] = UserDefaults.standard.array(forKey: "FavoriteNFTs") as? [String] ?? []
        if isLiked {
            favoriteNFTs.append(nft.id)
        } else {
            favoriteNFTs.removeAll { $0 == nft.id }
        }
        UserDefaults.standard.set(favoriteNFTs, forKey: "FavoriteNFTs")
        
        updateProfileLikes(profileId: "1", likes: favoriteNFTs)
    }
    
    private func updateProfileLikes(profileId: String, likes: [String]) {
        ProgressHUD.show()
        enableRightButton(false)
        print("Обновление лайков. Количество лайков: \(likes.count)")
        
        let params = UpdateProfileParams(profileId: profileId, likes: likes)
        
        nftService.updateProfile(params: params)
            .sink(receiveCompletion: { completion in
                ProgressHUD.dismiss()
                self.enableRightButton(true)
                switch completion {
                case .finished:
                    print("✅ Лайки успешно обновлены")
                    self.loadUsersNFTs(forProfileId: profileId)
                case .failure(let error):
                    print("⛔️ Ошибка при обновлении лайков: \(error)")
                }
            }, receiveValue: { updatedProfile in
                print("✅ Обновленный профиль: \(updatedProfile)")
            })
            .store(in: &cancellables)
    }
    
    private func loadUsersNFTs(forProfileId profileId: String) {
        ProgressHUD.show()
        enableRightButton(false)
        
        print("Loading NFTs for profile: \(profileId)")
        
        nftService.loadAllNfts(forProfileId: profileId)
            .sink(receiveCompletion: { [weak self] completion in
                ProgressHUD.dismiss()
                self?.enableRightButton(true)
                self?.refreshControl.endRefreshing()
                switch completion {
                case .finished:
                    self?.applySavedSortingMethod()
                    print("✅ Загрузка всех NFT для профиля завершена успешно")
                case .failure(let error):
                    print("⛔️ Ошибка загрузки всех NFT для профиля: \(error)")
                }
            }, receiveValue: { [weak self] nfts in
                print("Received NFTs: \(nfts.count)")
                nfts.forEach { print($0) }
                self?.nftsTableView.nfts = nfts
                self?.nftsTableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    
    //MARK: - Objcs
    
    @objc private func refreshNFTs() {
        loadUsersNFTs(forProfileId: "1")
    }
    
    @objc private func favoriteStatusChanged(_ notification: Notification) {
        guard notification.object is String else { return }
        nftsTableView.reloadData()
    }
    
    @objc private func leftButtonTapped() {
        leftToRightTransition()
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func rightButtonTapped() {
        sortNFTsBy()
    }
}

