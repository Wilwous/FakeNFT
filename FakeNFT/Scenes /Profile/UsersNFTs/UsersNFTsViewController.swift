//
//  UsersNFTsViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import Combine
import UIKit

final class UsersNFTsViewController: UIViewController {

    // MARK: - Properties

    private let noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет NFT"
        label.font = .bodyBold
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        return label
    }()

    private let nftsTableView = UsersNTFsTableView()
    private var cancellables = Set<AnyCancellable>()
    private let nftService: NftServiceCombine

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
        loadUsersNFTs(forProfileId: "1")
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

    @objc private func leftButtonTapped() {
        leftToRightTransition()
        dismiss(animated: false, completion: nil)
    }

    @objc private func rightButtonTapped() {
        //TODO:  Действие при нажатии на правую кнопку
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
}

extension UsersNFTsViewController {

    private func loadUsersNFTs(forProfileId profileId: String) {
        nftService.loadAllNfts(forProfileId: profileId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ Загрузка всех NFT для профиля завершена успешно")
                case .failure(let error):
                    print("⛔️ Ошибка загрузки всех NFT для профиля: \(error)")
                }
            }, receiveValue: { [weak self] nfts in
                print("✅ Получены данные NFT для профиля: \(nfts)")
                self?.nftsTableView.nfts = nfts.map {
                    (
                        imageUrl: URL(string: $0.images.first?.absoluteString ?? ""),
                        title: $0.name,
                        rating: $0.rating,
                        author: $0.author,
                        priceValue: "\($0.price) ETH"
                    )
                }
                self?.nftsTableView.reloadData()
                self?.noNFTLabel.isHidden = !self!.nftsTableView.nfts.isEmpty
            })
            .store(in: &cancellables)
    }
}

