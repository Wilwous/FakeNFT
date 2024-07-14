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
    var collectionsBinding: Binding<[NFTViewModel]>? { get set }
    var collections: [NFTViewModel] { get }
    var service: CatalogService? { get set }
    func fetchCollections()
    var showLoadingHandler: (() -> ())? { get set }
    var hideLoadingHandler: (() -> ())? { get set }
    func updateSorter(newSorting: SortState)
    func sorterCollections(collectionsToSort: [NFTViewModel]) -> [NFTViewModel]
}

// MARK: - ViewModel

final class CatalogViewModel: CatalogViewModelProtocol {
    
    // MARK: - Сlosure
    
    var showLoadingHandler: (() -> ())?
    var hideLoadingHandler: (() -> ())?
    
    // MARK: - Public Properties
    
    var collectionsBinding: Binding<[NFTViewModel]>?
    var service: CatalogService?
    
    // MARK: - Private Properties
    
    private let sorterStorage = CatalogSorterStorage.shared
    
    private(
        set
    ) var collections: [NFTViewModel] = [] {
        didSet {
            collectionsBinding?(
                collections
            )
        }
    }
    
    // MARK: - Initializer
    
    init(service: CatalogService) {
        self.service = service
    }
    
    //MARK: - Public Methods
    
    func updateSorter(
        newSorting: SortState
    ) {
        sorterStorage.sorterDescriptor = newSorting.rawValue
        collections = sorterCollections(
            collectionsToSort: collections
        )
        collectionsBinding?(collections)
    }
    
    func fetchCollections() {
        guard let service = service else {
            print(
                "Service not set"
            )
            return
        }
        
        showLoadingHandler?()
        service.getCollections { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(
                let nftCollectionsResult
            ):
                let convertedCollections = nftCollectionsResult.map { collection in
                    NFTViewModel(
                        nftCollection: NftCollection(
                            id: collection.id,
                            nfts: collection.nfts,
                            name: collection.name,
                            cover: collection.cover,
                            author: collection.author,
                            description: collection.description
                        )
                    )
                }
                self.collections = self.sorterCollections(
                    collectionsToSort: convertedCollections
                )
                self.hideLoadingHandler?()
            case .failure(let error):
                self.hideLoadingHandler?()
                print(
                    "Error fetching collections: \(error)"
                )
            }
        }
    }
    
    func sorterCollections(
        collectionsToSort: [NFTViewModel]
    ) -> [NFTViewModel] {
        guard let sortingRawValue = sorterStorage.sorterDescriptor,
              let sorting = SortState(
                rawValue: sortingRawValue
              ) else {
            return collectionsToSort
        }
        
        var sortedCollections: [NFTViewModel] = collectionsToSort
        switch sorting {
        case .name:
            sortedCollections.sort {
                $0.nftCollection.name < $1.nftCollection.name
            }
        case .quantity:
            sortedCollections.sort {
                $0.nftCollection.nfts.count > $1.nftCollection.nfts.count
            }
        }
        return sortedCollections
    }
}
