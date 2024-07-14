//
//  CollectionService.swift
//  FakeNFT
//
//  Created by Антон Павлов on 12.07.2024.
//

import Foundation

final class CollectionService {
    
    // MARK: - Private Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    
    func getNftById(
        id: String,
        completion: @escaping NftResultCompletion
    ) {
        let request = NFTRequest(id: id)
        networkClient.send(
            request: request,
            type: NftDetailsResponseModel.self
        ) { result in
            switch result {
            case .success(let nft): completion(.success(nft))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getMyCart(
        completion: @escaping (Result<[CartResponseModel],Error>
        ) -> Void) {
        
        let request = FetchCatalogsRequest()
        
        networkClient.send(
            request: request,
            type: [CartResponseModel].self
        ) { result in
            switch result {
            case .success(let cart): completion(.success(cart))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getMyFavourites(
        completion: @escaping ProfileInfoResultCompletion
    ) {
        let request = FetchCatalogsRequest()
        networkClient.send(
            request: request,
            type: UserProfileResponseModel.self
        ) { result in
            switch result {
            case .success(
                let likes): completion(.success(likes))
            case .failure(
                let error): completion(.failure(error))
            }
        }
    }
}
