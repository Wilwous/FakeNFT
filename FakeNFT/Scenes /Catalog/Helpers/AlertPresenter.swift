//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Антон Павлов on 03.07.2024.
//

import UIKit

final class AlertPresenter {
    
    // MARK: - Public Methods
    
    static func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: nil,
            message: model.message,
            preferredStyle: .actionSheet
        )
        
        let nameSort = UIAlertAction(
            title: model.nameSortText,
            style: .default
        ) { _ in
            model.sortNameCompletion()
        }
        
        alert.addAction(nameSort)
        
        let quantitySort = UIAlertAction(
            title: model.quantitySortText,
            style: .default
        ) { _ in model.sortQuantityCompletion()
        }
        
        alert.addAction(quantitySort)
        
        let cancelAction = UIAlertAction(
            title: model.cancelButtonText,
            style: .cancel
        )
        alert.addAction(cancelAction)
        vc.present(alert, animated: true)
    }
    
    // MARK: - Initializer
    
    private init() {}
}
