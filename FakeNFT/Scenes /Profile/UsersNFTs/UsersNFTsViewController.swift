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

    init(nftService: NftServiceCombine) {
        self.nftService = nftService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupRefreshControl()
        loadUsersNFTs(forProfileId: "1")
        setupBindings()
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

    private func sortNFTsBy() {
        setupDimmingView()
        let actionSheet = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)

        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.removeDimmingView()
            print("Сортировка по цене")
        }

        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.removeDimmingView()
            print("Сортировка по рейтингу")
        }

        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.removeDimmingView()
            print("Сортировка по названию")
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


    @objc private func favoriteStatusChanged(_ notification: Notification) {
        guard let nftId = notification.object as? String else { return }
        nftsTableView.reloadData()
    }

    @objc private func leftButtonTapped() {
        leftToRightTransition()
        dismiss(animated: false, completion: nil)
    }

    @objc private func rightButtonTapped() {
        sortNFTsBy()
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

    @objc private func refreshNFTs() {
        loadUsersNFTs(forProfileId: "1")
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
                case .failure(let error):
                    print("⛔️ Ошибка при обновлении лайков: \(error)")
                }
            }, receiveValue: { updatedProfile in
                print("✅ Обновленный профиль: \(updatedProfile)")
            })
            .store(in: &cancellables)
    }
}

extension UsersNFTsViewController {
    private func loadUsersNFTs(forProfileId profileId: String) {
        if !refreshControl.isRefreshing {
            ProgressHUD.show()
            enableRightButton(false)
        }

        nftService.loadAllNfts(forProfileId: profileId)
            .sink(receiveCompletion: { completion in
                ProgressHUD.dismiss()
                self.enableRightButton(true)
                self.refreshControl.endRefreshing()
                switch completion {
                case .finished:
                    print("✅ Загрузка всех NFT для профиля завершена успешно")
                case .failure(let error):
                    print("⛔️ Ошибка загрузки всех NFT для профиля: \(error)")
                }
            }, receiveValue: { [weak self] nfts in
                print("✅ Получены данные NFT для профиля: \(nfts)")
                self?.nftsTableView.nfts = nfts
                self?.nftsTableView.reloadData()
                self?.noNFTLabel.isHidden = !(self?.nftsTableView.nfts.isEmpty ?? true)
            })
            .store(in: &cancellables)
    }
}
