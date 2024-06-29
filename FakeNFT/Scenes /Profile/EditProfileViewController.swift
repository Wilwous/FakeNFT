//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 29.06.2024.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func didSaveProfile(name: String, avatar: String, description: String, site: String)
}

final class EditProfileViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: EditProfileDelegate?

    private var userName: String
    private var userAvatar: String
    private var descriptionText: String
    private var userSite: String

    // UI Elements
    private let avatarImageView = UIImageView()
    private let nameTextField = CustomTextField(title: "Имя", placeholder: "Введите имя")
    private let descriptionTextField = CustomTextField(title: "Описание", placeholder: "Введите описание")
    private let siteTextField = CustomTextField(title: "Сайт", placeholder: "Введите сайт")
    private let saveButton = UIButton(type: .system)

    // MARK: - Initializer
    init(userName: String, userAvatar: String, descriptionText: String, userSite: String) {
        self.userName = userName
        self.userAvatar = userAvatar
        self.descriptionText = descriptionText
        self.userSite = userSite
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white

        // Configure UI elements
        avatarImageView.image = UIImage(named: userAvatar)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true

        nameTextField.text = userName
        descriptionTextField.text = descriptionText
        siteTextField.text = userSite

        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        // Add UI elements to view
        view.addSubview(avatarImageView)
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(siteTextField)
        view.addSubview(saveButton)
    }

    private func setupConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        siteTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 94),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            siteTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            siteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            saveButton.topAnchor.constraint(equalTo: siteTextField.bottomAnchor, constant: 22),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func saveTapped() {
        delegate?.didSaveProfile(name: nameTextField.text ?? "", avatar: "avatar_photo", description: descriptionTextField.text ?? "", site: siteTextField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
}
