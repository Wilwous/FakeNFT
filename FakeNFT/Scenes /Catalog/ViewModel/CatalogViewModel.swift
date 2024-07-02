//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import Foundation

// MARK: - Protocol

protocol CatalogViewModelProtocol {
    var collectionsBinding: Binding<[CollectionViewModel]>? { get set }
    var collections: [CollectionViewModel] { get }
    var service: CatalogService? { get set }
    func fetchCollections()
}

// MARK: - ViewModel

final class CatalogViewModel: CatalogViewModelProtocol {
    
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
        service.getCollections { [weak self] result in
            switch result {
            case .success(let nftCollectionsResult):
                let viewModels = nftCollectionsResult.map {
                    CollectionViewModel(
                        nftCollection: $0
                    )
                }
                self?.collections = viewModels
            case .failure(let error):
                print("Error fetching collections: \(error)")
            }
        }
    }
}
