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
    func sortCatalogByName()
    func sortCatalogByQuantity()
    func sortCatalog()
}

// MARK: - ViewModel

final class CatalogViewModel: CatalogViewModelProtocol {
    
    // MARK: - Сlosure
    
    var showLoadingHandler: (() -> ())?
    var hideLoadingHandler: (() -> ())?
    
    // MARK: - Public Properties
    
    var collectionsBinding: Binding<[CollectionViewModel]>?
    var service: CatalogService?
    var catalog: [NftCollection] = []
    
    // MARK: - Private Properties
    
    private(set)var sort: SortState?
    
    // MARK: - Initializer
    
    init(service: CatalogService) {
        self.service = service
        self.sort = SortState(
            rawValue: CatalogSorterStorage.shared.sorterDescriptor ??
            SortState.quantity.rawValue
        )
    }
    
    // MARK: - Private Properties
    
    private(set) var collections: [CollectionViewModel] = [] {
        didSet {
            collectionsBinding?(collections)
        }
    }
    
    //MARK: - Public methods
    
    func sortCatalog() {
        switch sort {
        case .name:
            sortCatalogByName()
        case .quantity:
            sortCatalogByQuantity()
        default:
            sortCatalogByQuantity()
        }
    }
    
    func sortCatalogByName() {
        catalog.sort { $0.name < $1.name }
        updateCollections()
        CatalogSorterStorage.shared.sorterDescriptor = SortState.name.rawValue
    }
    
    func sortCatalogByQuantity() {
        catalog.sort { $0.nfts.count > $1.nfts.count }
        updateCollections()
        CatalogSorterStorage.shared.sorterDescriptor = SortState.quantity.rawValue
    }
    
    func fetchCollections() {
        guard let service = service else {
            print("Service not set")
            return
        }
        
        showLoadingHandler?()
        service.getCollections { [weak self] result in
            switch result {
            case .success(let nftCollectionsResult):
                self?.catalog = nftCollectionsResult
                self?.sortCatalog()
                self?.hideLoadingHandler?()
            case .failure(let error):
                self?.hideLoadingHandler?()
                print("Error fetching collections: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateCollections() {
        self.collections = catalog.map { CollectionViewModel(nftCollection: $0) }
    }
}
