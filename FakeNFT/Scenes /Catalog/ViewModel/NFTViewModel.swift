//
//  NFTViewModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import UIKit

final class NFTViewModel {
    
    // MARK: - Public Properties
    
    var id: String {
        return nftCollection.id
    }
    
    var name: String {
        return convertCollectionName()
    }
    
    var coverURL: String {
        return nftCollection.cover
    }
    
    var author: String {
        return nftCollection.author
    }
    
    var description: String {
        return nftCollection.description
    }
    
    var nfts: [String] {
        return nftCollection.nfts
    }
    
    // MARK: - Private Properties
    
    let nftCollection: NftCollection
    
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
