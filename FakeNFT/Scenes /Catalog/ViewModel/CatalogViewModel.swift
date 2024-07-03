//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import Foundation
import ProgressHUD

// MARK: - Protocol

protocol CatalogViewModelProtocol {
    var collectionsBinding: Binding<[CollectionViewModel]>? { get set }
    var collections: [CollectionViewModel] { get }
    var service: CatalogService? { get set }
    func fetchCollections()
    var showLoadingHandler: (() -> ())? { get set }
    var hideLoadingHandler: (() -> ())? { get set }
}

// MARK: - ViewModel

final class CatalogViewModel: CatalogViewModelProtocol {
    
    // MARK: - Сlosure
    
    var showLoadingHandler: (() -> ())?
    var hideLoadingHandler: (() -> ())?
    
    // MARK: - Public Properties
    
    var collectionsBinding: Binding<[CollectionViewModel]>?
    var service: CatalogService?
    
    // MARK: - Initializer
    
    init(service: CatalogService) {
        self.service = service
    }
    
    // MARK: - Private Properties
    
    private(set) var collections: [CollectionViewModel] = [] {
        didSet {
            collectionsBinding?(collections)
        }
    }
    
    // MARK: - Public Methods
    
    func fetchCollections() {
        guard let service = service else {
            print("Service not set")
            return
        }
        
        let convertedCollections: [CollectionViewModel] = []
        showLoadingHandler?()
        service.getCollections { [weak self] result in
            switch result {
            case .success(let nftCollectionsResult):
                let viewModels = nftCollectionsResult.map {
                    CollectionViewModel(
                        nftCollection: $0
                    )
                }
                self?.collections = viewModels
                self?.hideLoadingHandler?()
            case .failure(let error):
                self?.hideLoadingHandler?()
                print("Error fetching collections: \(error)")
            }
        }
    }
}
