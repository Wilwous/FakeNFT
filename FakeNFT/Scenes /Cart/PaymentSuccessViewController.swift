//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 13/07/2024.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    
    // MARK: - UI Components
    
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
        label.numberOfLines = 2
        label.font = .headline3
        return label
    }()
    
    private let returnButton: UIButton = ActionButton(
        size: .large,
        type: .primary,
        title: "Вернуться в каталог"
    )
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Methods
    
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
    
    // MARK: - Actions
    
    @objc private func didTapReturnButton() {
        if let navigationController = navigationController {
            for controller in navigationController.viewControllers {
                if let cartVC = controller as? CartViewController {
                    cartVC.cartViewModel.clearCartSubject.send()
                    navigationController.popToViewController(cartVC, animated: true)
                    return
                }
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
