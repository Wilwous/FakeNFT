//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import UIKit

// MARK: - Network

final class CatalogService {
    
    // MARK: - Private Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    
    func getCollections(completion: @escaping NftCollectionCompletion) {
        let request = NFTCollectionRequest()
        networkClient.send(
            request: request,
            type: [NftCollection].self
        ) { [weak self] result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
