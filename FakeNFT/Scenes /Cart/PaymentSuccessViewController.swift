//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 13/07/2024.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    
    private let successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.textAlignment = .center
        label.font = .headline3
        return label
    }()
    
    private let returnButton: UIButton = ActionButton(
        size: .large,
        type: .primary,
        title: "Вернуться в каталог"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        [successImageView, successLabel, returnButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            
            returnButton.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 152),
            returnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
    }
    
    @objc private func didTapReturnButton() {
        //TODO: Return to cart and refresh cart data
    }
}
