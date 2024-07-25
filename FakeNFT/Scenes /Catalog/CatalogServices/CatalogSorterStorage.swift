//
//  CatalogFilterStorage.swift
//  FakeNFT
//
//  Created by Антон Павлов on 03.07.2024.
//

import Foundation

enum SortState: String {
    case name = "name"
    case quantity = "quantity"
}

final class CatalogSorterStorage {
    
    // MARK: - Singleton
    
    static let shared = CatalogSorterStorage()
    
    // MARK: - Public Properties
    
    var sorterDescriptor: String? {
        get {
            userDefaults.string(forKey: Constants.filterKey)
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: Constants.filterKey)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var userDefaults = UserDefaults.standard
    
    // MARK: - Initializer
    
    private init() {}
}
