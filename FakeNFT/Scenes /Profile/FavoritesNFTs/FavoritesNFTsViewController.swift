//
//  FavoritesNFTsViewController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 30.06.2024.
//

import UIKit

final class FavoritesNFTsViewController: UIViewController {
    
    // MARK: - Properties
    private let noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
        label.font = .bodyBold
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
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
        view.backgroundColor = .ypWhiteDay
        view.addSubview(noNFTLabel)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        noNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

