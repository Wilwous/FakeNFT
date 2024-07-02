//
//  CatalogSingleCollectionViewModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import UIKit

final class CollectionViewModel {
    
    // MARK: - Public Properties
    
    var name: String {
        return convertCollectionName()
    }
    
    var coverURL: String {
        return nftCollection.cover
    }
    
    // MARK: - Private Properties
    
    private let nftCollection: NftCollection
    
    // MARK: - Initializer
    
    init(nftCollection: NftCollection) {
        self.nftCollection = nftCollection
    }
    
    // MARK: - Private Methods
    
    private func convertCollectionName() -> String {
        let result = nftCollection.name + " (" + String(
            nftCollection.nfts.count
        ) + ")"
        
        return result
    }
}
