//
//  CollectionService.swift
//  FakeNFT
//
//  Created by Антон Павлов on 12.07.2024.
//

import Foundation

// MARK: - Network

final class CollectionService {
    
    // MARK: - Private Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    
    func getNftById(id: String, completion: @escaping NftResultCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(
            request: request,
            type: NftResultModel.self
        ) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMyCart(completion: @escaping CartResultCompletion) {
        let request = GetCartRequest()
        networkClient.send(
            request: request,
            type: CartResponseModel.self
        ) { result in
            switch result {
            case .success(let cart):
                completion(.success(cart))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMyFavourites(completion: @escaping ProfileInfoResultCompletion) {
        let request = FetchLikesRequest(token: RequestConstants.tokenValue)
        self.networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let userInfo = try JSONDecoder().decode(
                        UserProfileResponseModel.self,
                        from: data
                    )
                    completion(.success(userInfo))
                } catch {
                    print("Parsing error in getMyFavourites: \(error)")
                    completion(.failure(NetworkClientError.parsingError))
                }
            case .failure(let error):
                print("Error in getMyFavourites: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func changeLikes(likeId: String, completion: @escaping LikesResultCompletion) {
        getMyFavourites { result in
            switch result {
            case .success(let userInfo):
                let oldLikes = userInfo.likes
                var newLikes: [String] = []
                if oldLikes.contains(likeId) {
                    newLikes = oldLikes.filter() { $0 != likeId }
                } else {
                    newLikes = oldLikes
                    newLikes.append(likeId)
                }
                let convertedLikes = newLikes.joined(separator: ",")
                let tokenValue = newLikes.isEmpty ? "likes=null" : "likes=\(convertedLikes)"
                let request = FetchLikesRequest(token: tokenValue)
                
                self.networkClient.send(
                    request: request,
                    type: LikesResultModel.self
                ) { result in
                    switch result {
                    case .success(let likes):
                        completion(.success(likes))
                    case .failure(let error):
                        print("Error in changeLikes: \(error)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Error in changeLikes - getMyFavourites: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateNftCartState(nftId: String, completion: @escaping CartResultCompletion) {
        getMyCart { [weak self] result in
            switch result {
            case .success(let cart):
                let oldCart = cart.nfts
                var newCart: [String] = []
                if oldCart.contains(nftId) {
                    newCart = oldCart.filter(){$0 != nftId}
                } else {
                    newCart = oldCart
                    newCart.append(nftId)
                }
                let convertedCart = newCart.isEmpty ? "null" : newCart.joined(separator: ",")
                let request = UpdateCartRequest(token: "nfts=\(convertedCart)")
                
                self?.networkClient.send(
                    request: request,
                    type: CartResponseModel.self
                ) { result in
                    switch result {
                    case .success(let cart):
                        completion(.success(cart))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
