//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 21.06.2024.
//

import UIKit

final class ProfileViewController: UIViewController, EditProfileDelegate {

    //MARK: - Properties

    private var userName: String = "Joaquin Phoenix"
    private var userAvatar: UIImage? = UIImage(named: "avatar_photo")
    private var descriptionText = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    private var userSite: String = "google.com"

    private var textContainer = UIView()
    private var userProfileContainer = UIView()
    private var profileTableView = ProfileTableView()

    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addProfileTableView()
        setupNavigationBar()
        setupUserInfoView()
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

        let avatarImage = UIImageView()
        avatarImage.image = userAvatar // 🤡
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
        userSiteLabel.numberOfLines = 1
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
            userSiteLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
            userSiteLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        return descriptionView
    }

    @objc func handleSiteTap() {
        let formattedURL = formatUrl(userSite)
        let webViewController = WebViewController()
        webViewController.targetURL = formattedURL
        let navController = UINavigationController(rootViewController: webViewController)
        navController.modalPresentationStyle = .fullScreen

        present(navController, animated: true, completion: nil)
    }

    private func formatUrl(_ url: String) -> String {
        if !url.lowercased().starts(with: "http://") && !url.lowercased().starts(with: "https://") {
            return "https://" + url
        }
        return url
    }

    private func addProfileTableView() {
        profileTableView = ProfileTableView()
        addChild(profileTableView)
        view.addSubview(profileTableView.tableView)

        profileTableView.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileTableView.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileTableView.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileTableView.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        profileTableView.didMove(toParent: self)
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

    // MARK: - EditProfileDelegate

    func didSaveProfile(name: String, avatar: UIImage?, description: String, site: String) { // 🤡
        self.userName = name
        self.userAvatar = avatar
        self.descriptionText = description
        self.userSite = site

        userProfileContainer.removeFromSuperview()
        textContainer.removeFromSuperview()
        setupUserInfoView()
    }
}
