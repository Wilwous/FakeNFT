//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 29.06.2024.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func didSaveProfile(name: String, avatar: UIImage?, description: String, site: String)
}

final class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    weak var delegate: EditProfileDelegate?
    
    private var userName: String
    private var userAvatar: UIImage?
    private var descriptionText: String
    private var userSite: String
    
    private let avatarImageView = UIImageView()
    private let avatarOverlayView = UIView()
    private let changePhotoLabel = UILabel()
    private let nameTextField = CustomTextField(title: "Имя", placeholder: "Введите имя")
    private let descriptionTextField = CustomTextField(title: "Описание", placeholder: "Введите описание")
    private let siteTextField = CustomTextField(title: "Сайт", placeholder: "Введите сайт")
    private let saveButton = UIButton(type: .system)
    private let warningLabel = UILabel()
    
    // MARK: - Initializer
    
    init(userName: String, userAvatar: UIImage?, descriptionText: String, userSite: String) {
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
        setupGestureRecognizers()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        avatarImageView.image = userAvatar ?? UIImage(named: "avatar_stub")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        
        avatarOverlayView.backgroundColor = .ypBlack.withAlphaComponent(0.6)
        avatarOverlayView.layer.cornerRadius = 35
        avatarOverlayView.clipsToBounds = true
        
        changePhotoLabel.text = "Сменить\nфото"
        changePhotoLabel.textColor = .ypWhite
        changePhotoLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        changePhotoLabel.textAlignment = .center
        changePhotoLabel.numberOfLines = 0
        changePhotoLabel.lineBreakMode = .byWordWrapping
        
        nameTextField.text = userName
        descriptionTextField.text = descriptionText
        siteTextField.text = userSite
        
        warningLabel.text = ""
        warningLabel.textColor = .ypRed
        warningLabel.isHidden = true
        warningLabel.font = .caption2
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        view.addSubview(avatarImageView)
        view.addSubview(avatarOverlayView)
        view.addSubview(changePhotoLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(siteTextField)
        view.addSubview(saveButton)
        view.addSubview(warningLabel)
    }
    
    private func setupConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarOverlayView.translatesAutoresizingMaskIntoConstraints = false
        changePhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        siteTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 94),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            avatarOverlayView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            avatarOverlayView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            avatarOverlayView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            avatarOverlayView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            changePhotoLabel.centerXAnchor.constraint(equalTo: avatarOverlayView.centerXAnchor),
            changePhotoLabel.centerYAnchor.constraint(equalTo: avatarOverlayView.centerYAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            warningLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            siteTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            siteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: siteTextField.bottomAnchor, constant: 22),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        avatarImageView.isUserInteractionEnabled = true
        avatarOverlayView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        avatarOverlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func selectPhoto() {
        print("Select Photo tapped")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Photo library not available")
        }
    }
    
    @objc private func saveTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            warningLabel.text = "Имя не может быть пустым"
            warningLabel.isHidden = false
            nameTextField.setBorder(color: .ypRed, width: 1)
            return
        }
        
        warningLabel.isHidden = true
        nameTextField.setBorder(color: .clear, width: 0)
        
        delegate?.didSaveProfile(name: name, avatar: avatarImageView.image, description: descriptionTextField.text ?? "", site: siteTextField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            avatarImageView.image = selectedImage
            avatarImageView.contentMode = .scaleAspectFill
            print("Image selected")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
