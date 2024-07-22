//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 21.06.2024.
//

import Combine
import Kingfisher
import UIKit
import ProgressHUD

final class ProfileViewController: UIViewController, EditProfileDelegate {

    //MARK: - Properties

    private let unifiedService: NftServiceCombine
    private var cancellables = Set<AnyCancellable>()
    private var currentProfile: Profile?

    private let avatarImage = UIImageView()
    private var userName: String = ""
    private var userAvatar: UIImage? = UIImage(named: "avatar_stub")
    private var descriptionText = ""
    private var userSite: String = ""

    private var textContainer = UIView()
    private var userProfileContainer = UIView()
    private var profileTableView: ProfileTableView

    private var isLoading: Bool = true {
        didSet {
            updateEditButtonVisibility()
        }
    }

    // MARK: - Initializer

    init(unifiedService: NftServiceCombine) {
        self.unifiedService = unifiedService
        self.profileTableView = ProfileTableView(unifiedService: unifiedService)
        super.init(nibName: nil, bundle: nil)

        profileTableView.onDeveloperCellTap = { [weak self] in
            self?.handleSiteTap()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addProfileTableView()
        setupNavigationBar()
        loadUserProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileTableView.updateFavoritesNFTCount()
    }

    //MARK: - Private Methods

    private func setupUserInfoView() {
        userProfileContainer = createUserProfileView()
        textContainer = createDescriptionView()

        view.addSubview(userProfileContainer)
        view.addSubview(textContainer)
        view.addSubview(profileTableView.tableView)

        userProfileContainer.translatesAutoresizingMaskIntoConstraints = false
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userProfileContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            userProfileContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userProfileContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            textContainer.topAnchor.constraint(equalTo: userProfileContainer.bottomAnchor, constant: 20),
            textContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            profileTableView.tableView.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 44),
            profileTableView.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileTableView.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileTableView.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func createUserProfileView() -> UIView {
        let userProfileView = UIView()
        avatarImage.image = userAvatar
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.cornerRadius = 35
        avatarImage.clipsToBounds = true
        userProfileView.addSubview(avatarImage)

        let userNameLabel = UILabel()
        userNameLabel.text = userName
        userNameLabel.font = .headline3
        userNameLabel.textColor = .ypBlackDay
        userNameLabel.numberOfLines = 3
        userProfileView.addSubview(userNameLabel)

        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.leadingAnchor.constraint(equalTo: userProfileView.leadingAnchor),
            avatarImage.topAnchor.constraint(equalTo: userProfileView.topAnchor),
            avatarImage.bottomAnchor.constraint(equalTo: userProfileView.bottomAnchor),

            userNameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            userNameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: userProfileView.trailingAnchor)
        ])
        return userProfileView
    }

    private func createDescriptionView() -> UIView {
        let descriptionView = UIView()

        let descriptionLabel = UILabel()
        descriptionLabel.text = descriptionText
        descriptionLabel.font = .caption2
        descriptionLabel.textColor = .ypBlackDay
        descriptionLabel.numberOfLines = 0

        let userSiteLabel = UILabel()
        userSiteLabel.text = userSite
        userSiteLabel.font = .caption1
        userSiteLabel.textColor = .ypBlue
        userSiteLabel.numberOfLines = 3
        userSiteLabel.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSiteTap))
        userSiteLabel.addGestureRecognizer(tapGesture)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        userSiteLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionView.addSubview(descriptionLabel)
        descriptionView.addSubview(userSiteLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),

            userSiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            userSiteLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            userSiteLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            userSiteLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor)
        ])
        return descriptionView
    }

    private func formatUrl(_ url: String) -> String {
        if !url.lowercased().starts(with: "http://") && !url.lowercased().starts(with: "https://") {
            return "https://" + url
        }
        return url
    }

    private func addProfileTableView() {
        let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl())
        let customServicesAssembly = CustomServicesAssembly(servicesAssembly: servicesAssembly)

        guard (try? customServicesAssembly.createProfileViewController()) != nil else {
            print("⛔️ Ошибка при создании ProfileViewController")
            return
        }

        profileTableView = ProfileTableView(unifiedService: unifiedService)
        addChild(profileTableView)
        view.addSubview(profileTableView.tableView)

        profileTableView.onDeveloperCellTap = { [weak self] in
            self?.handleSiteTap()
        }

        profileTableView.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileTableView.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileTableView.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileTableView.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        profileTableView.didMove(toParent: self)
    }

    private func updateEditButtonVisibility() {
        if isLoading {
            navigationItem.rightBarButtonItem = nil
        } else {
            let rightBarItem = UIBarButtonItem(
                image: UIImage(named: "edit"),
                style: .plain,
                target: self,
                action: #selector(didTapEditButton)
            )
            rightBarItem.tintColor = .ypBlackDay
            navigationItem.rightBarButtonItem = rightBarItem
        }
    }

    private func setupNavigationBar() {
        let rightBarItem = UIBarButtonItem(
            image: UIImage(named: "edit"),
            style: .plain,
            target: self,
            action: #selector(didTapEditButton)
        )
        rightBarItem.tintColor = .ypBlackDay
        navigationItem.rightBarButtonItem = rightBarItem
        updateEditButtonVisibility()
    }

    // MARK: - EditProfileDelegate

    func didSaveProfile(
        name: String,
        avatar: String?,
        description: String,
        site: String
    ) {
        self.userName = name
        self.descriptionText = description
        self.userSite = site

        if let avatarURLString = avatar, let avatarURL = URL(string: avatarURLString) {
            do {
                let imageData = try Data(contentsOf: avatarURL)
                self.userAvatar = UIImage(data: imageData)
            } catch {
                print("⛔️ Ошибка загрузки аватарки: \(error)")
                self.userAvatar = nil
            }
        } else {
            self.userAvatar = nil
        }

        userProfileContainer.removeFromSuperview()
        textContainer.removeFromSuperview()
        setupUserInfoView()

        let params = UpdateProfileParams(
            name: name,
            description: description,
            website: site,
            avatar: avatar
        )

        unifiedService.updateProfile(params: params)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("⛔️ Не удалось обновить профиль: \(error)")
                }
            }, receiveValue: { updatedProfile in
                self.currentProfile = updatedProfile
                self.updateUI(with: updatedProfile)
            })
            .store(in: &cancellables)
    }

    func updateProfileLikes(profileId: String = "1", likes: [String]) {
        let params = UpdateProfileParams(likes: likes)
        unifiedService.updateProfile(params: params)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ Лайки успешно обновлены")
                case .failure(let error):
                    print("⛔️ Ошибка при обновлении лайков: \(error)")
                }
            }, receiveValue: { updatedProfile in
                self.currentProfile = updatedProfile
                self.updateUI(with: updatedProfile)
            })
            .store(in: &cancellables)
    }

    @objc private func didTapEditButton() {

        let editVC = EditProfileViewController(
            userName: userName,
            userAvatar: userAvatar,
            descriptionText: descriptionText,
            userSite: userSite
        )

        editVC.delegate = self
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true, completion: nil)
    }

    @objc func handleSiteTap() {
        let formattedURL = formatUrl(userSite)
        let webViewController = WebViewController()
        webViewController.targetURL = formattedURL
        let navController = UINavigationController(rootViewController: webViewController)
        navController.modalPresentationStyle = .fullScreen
        navController.view.layer.add(makeTransition(), forKey: kCATransition)
        present(navController, animated: false, completion: nil)
    }

    private func makeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromRight
        return transition
    }
}

extension ProfileViewController {

    private func loadUserProfile() {
        ProgressHUD.show()
        isLoading = true
        unifiedService.loadProfile(id: "1")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    ProgressHUD.dismiss()
                    self.isLoading = false
                    print("⛔️ Не удалось загрузить профиль: \(error)")
                }
            }, receiveValue: { [weak self] profile in
                self?.currentProfile = profile
                self?.updateUI(with: profile)
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }

    private func updateUI(with profile: Profile) {
        userName = profile.name
        descriptionText = profile.description
        userSite = profile.website

        if let url = URL(string: profile.avatar) {
            avatarImage.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.userAvatar = value.image
                case .failure(let error):
                    print("⛔️ Ошибка загрузки аватарки: \(error)")
                }
                self.updateProfileContainer()
                ProgressHUD.dismiss()
                self.isLoading = false
            }
        } else {
            updateProfileContainer()
            ProgressHUD.dismiss()
            self.isLoading = false
        }

        profileTableView.myNFTsCount = profile.nfts.count
        profileTableView.favoritesNFTsCount = profile.likes.count
        profileTableView.tableView.reloadData()
        updateProfileContainer()
    }

    private func updateProfileContainer() {
        userProfileContainer.removeFromSuperview()
        textContainer.removeFromSuperview()
        setupUserInfoView()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
