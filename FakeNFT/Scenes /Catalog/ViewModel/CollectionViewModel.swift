//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 11.07.2024.
//

import Foundation

// MARK: - Protocol

protocol CollectionViewModelProtocol {
    var collectionInformation: NftCollection { get }
    var nftsBinding: (([NftCellModel]) -> Void)? { get set }
    var showLoadingHandler: (() -> Void)? { get set }
    var hideLoadingHandler: (() -> Void)? { get set }
    var errorHandler: (() -> Void)? { get set }
    var nfts: [NftCellModel] { get }
    
    func fetchDataToDisplay()
}

// MARK: - ViewModel

final class CollectionViewModel: CollectionViewModelProtocol {
    
    // MARK: - Сlosure
    
    var nftsBinding: (([NftCellModel]) -> Void)?
    var showLoadingHandler: (() -> Void)?
    var hideLoadingHandler: (() -> Void)?
    var errorHandler: (() -> Void)?
    
    // MARK: - Public Properties
    let collectionInformation: NftCollection
    var websiteLink = "https://rroll.to/iHgSMg"
    
    // MARK: - Private Properties
    
    private let service: CollectionService
    private let numberOfNftsToLoad: Int
    
    private var likedNfts: Set<String> = []
    private var nftsInCart: Set<String> = []
    
    private(set) var nfts: [NftCellModel] = [] {
        didSet {
            nftsBinding?(nfts)
        }
    }
    
    // MARK: - Initializer
    
    init(collectionInfo: NftCollection) {
        self.collectionInformation = collectionInfo
        self.service = CollectionService(networkClient: DefaultNetworkClient())
        self.numberOfNftsToLoad = collectionInfo.nfts.count
    }
    
    // MARK: - Public Methods
    
    func fetchDataToDisplay() {
        self.showLoadingHandler?()
        fetchData { [weak self] result in
            self?.hideLoadingHandler?()
            switch result {
            case .success(let nfts):
                self?.nfts = Array(nfts.prefix(self?.numberOfNftsToLoad ?? 0))
                self?.loadLikes()
            case .failure(let error):
                print("Error fetching NFTs: \(error)")
                self?.errorHandler?()
            }
        }
    }
    
    func didLikeButtonTapped(nftId: String, completion: @escaping (Bool) -> ()) {
        service.changeLikes(likeId: nftId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let likes):
                    if let index = self.nfts.firstIndex(where: { $0.id == nftId }) {
                        self.nfts[index].isLiked = likes.likes.contains(nftId)
                    }
                    self.nftsBinding?(self.nfts)
                    completion(likes.likes.contains(nftId))
                case .failure(let error):
                    self.errorHandler?()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateLikes(likes: [String]) {
        self.likedNfts = Set(likes)
        for i in 0..<nfts.count {
            nfts[i].isLiked = likedNfts.contains(nfts[i].id)
        }
        self.nftsBinding?(self.nfts)
    }
    
    private func loadLikes() {
        service.getMyFavourites { [weak self] result in
            switch result {
            case .success(let profile):
                self?.likedNfts = Set(profile.likes)
                self?.updateNftsWithLikes()
            case .failure(let error):
                print("Error fetching favourites: \(error)")
            }
        }
    }
    
    private func updateNftsWithLikes() {
        for i in 0..<nfts.count {
            nfts[i].isLiked = likedNfts.contains(nfts[i].id)
        }
        nftsBinding?(nfts)
    }
    
    private func fetchData(
        completion: @escaping (Result<[NftCellModel], Error>
        ) -> Void) {
        service.getMyCart { [weak self] result in
            switch result {
            case .success(let collections):
                var fetchedNfts: [NftCellModel] = []
                let group = DispatchGroup()
                
                for collection in collections {
                    for id in collection.nfts.prefix(self?.numberOfNftsToLoad ?? 0) {
                        group.enter()
                        self?.service.getNftById(id: id) { result in
                            switch result {
                            case .success(let nftResult):
                                let nft = NftCellModel(
                                    cover: nftResult.images.first!,
                                    name: nftResult.name,
                                    stars: nftResult.rating,
                                    isLiked: self?.checkIfNftIsLiked(id: nftResult.id) ?? false,
                                    price: nftResult.price,
                                    isInCart: self?.checkIfNftIsInCart(id: nftResult.id) ?? false,
                                    id: nftResult.id
                                )
                                fetchedNfts.append(nft)
                            case .failure(let error):
                                print("Error fetching NFT by ID: \(error)")
                                completion(.failure(error))
                            }
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(fetchedNfts))
                }
            case .failure(let error):
                print("Error fetching collections: \(error)")
                self?.handleResult(result: .failure(error), completion: completion)
            }
        }
    }
    
    private func handleResult<T>(
        result: Result<T, Error>, completion: @escaping (Result <T, Error>
        ) -> Void) {
        DispatchQueue.main.async {
            switch result {
            case .success(let succes):
                completion(.success(succes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getMyLikes(
        completion: @escaping ProfileInfoResultCompletion
    ) {
        service.getMyFavourites { result in
            switch result {
            case .success(let userInfo):
                completion(.success(userInfo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getNfts(
        completion: @escaping (Result<[NftCellModel], Error>
        ) -> Void
    ) {
        let group = DispatchGroup()
        var fetchedNfts: [NftDetailsResponseModel] = []
        
        for id in collectionInformation.nfts.prefix(numberOfNftsToLoad) {
            group.enter()
            service.getNftById(id: id) { result in
                switch result {
                case .success(let nftResult):
                    fetchedNfts.append(nftResult)
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let allNfts = fetchedNfts.map {
                return NftCellModel(
                    cover: $0.images.first!,
                    name: $0.name,
                    stars: $0.rating,
                    isLiked: self.checkIfNftIsLiked(id: $0.id),
                    price: $0.price,
                    isInCart: self.checkIfNftIsInCart(id: $0.id),
                    id: $0.id
                )
            }
            completion(.success(allNfts))
        }
    }
    
    private func checkIfNftIsLiked(id: String) -> Bool {
        return likedNfts.contains(id)
    }
    
    private func checkIfNftIsInCart(id: String) -> Bool {
        return nftsInCart.contains(id)
    }
}
