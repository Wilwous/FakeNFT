//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 03.07.2024.
//

import Foundation

// MARK: - Model

struct AlertModel {
    let message: String
    let nameSortText: String
    let quantitySortText: String
    let cancelButtonText: String
    let sortNameCompletion: () -> ()
    let sortQuantityCompletion: () -> ()
}
