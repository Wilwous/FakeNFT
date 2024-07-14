import Combine
import Foundation

// MARK: - Typealiases

typealias NftCombineCompletion = AnyPublisher<Nft, NetworkClientError>
typealias NftListCombineCompletion = AnyPublisher<[Nft], NetworkClientError>
typealias CartItemsCompletion = AnyPublisher<[Nft], NetworkClientError>
typealias OrderCompletion = AnyPublisher<Order, NetworkClientError>
typealias ProfileCombineCompletion = AnyPublisher<Profile, NetworkClientError>
typealias CurrencyCombineCompletion = AnyPublisher<[Currency], NetworkClientError>
typealias OrderPaymentResponseCompletion = AnyPublisher<OrderPaymentResponse, NetworkClientError>

// MARK: - NftServiceCombine

protocol NftServiceCombine {
    
    //MARK: NFT Methods
    
    func loadNft(id: String) -> NftCombineCompletion
    func loadAllNfts(forProfileId profileId: String) -> NftListCombineCompletion
    func loadFavoriteNfts(profileId: String) -> NftListCombineCompletion
    
    //MARK: Profile Methods
    
    func loadProfile(id: String) -> ProfileCombineCompletion
    func updateProfile(params: UpdateProfileParams) -> ProfileCombineCompletion
    
    //MARK: Cart Methods
    
    func getCartItems() -> CartItemsCompletion
    func updateOrder(id: String, nftIds: [String]) -> OrderCompletion
    
    //MARK: Currency and Payment Methods
    
    func loadCurrencies() -> CurrencyCombineCompletion
    func payOrder(with currency: Currency) -> OrderPaymentResponseCompletion
}

final class NftServiceCombineImp: NftServiceCombine {
    private let networkClient: NetworkClientCombine
    private let storage: NftStorage
    private let apiRequestBuilder: ApiRequestBuilderProtocol
    private var currentOrderId: String = "1"
    
    init(
        networkClient: NetworkClientCombine,
        storage: NftStorage,
        apiRequestBuilder: ApiRequestBuilderProtocol
    ) {
        self.networkClient = networkClient
        self.storage = storage
        self.apiRequestBuilder = apiRequestBuilder
    }
    
    // MARK: - NFT Methods
    
    func loadNft(id: String) -> NftCombineCompletion {
        if let cachedNft = storage.getNft(with: id) {
            return Just(cachedNft)
                .setFailureType(to: NetworkClientError.self)
                .handleEvents(receiveOutput: { nft in
                    print("Cached NFT loaded: \(nft)")
                })
                .eraseToAnyPublisher()
        }
        
        guard let request = apiRequestBuilder.getNft(nftId: id) else {
            return Fail(error: NetworkClientError.custom("Invalid NFT ID for request"))
                .eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Nft.self)
            .handleEvents(receiveOutput: { [weak self] nft in
                self?.storage.saveNft(nft)
            })
            .eraseToAnyPublisher()
    }
    
    func loadAllNfts(forProfileId profileId: String) -> NftListCombineCompletion {
        guard let profileRequest = apiRequestBuilder.getProfile(profileId: profileId) else {
            return Fail(error: NetworkClientError.custom("Invalid profile ID for request"))
                .eraseToAnyPublisher()
        }
        
        return networkClient.send(request: profileRequest, type: Profile.self)
            .flatMap { profile -> NftListCombineCompletion in
                let nftPublishers = profile.nfts.map { nftId in
                    self.loadNft(id: nftId).eraseToAnyPublisher()
                }
                return Publishers.MergeMany(nftPublishers).collect().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func loadFavoriteNfts(profileId: String) -> NftListCombineCompletion {
        guard let request = apiRequestBuilder.getProfile(profileId: profileId) else {
            return Fail(error: NetworkClientError.custom("Invalid Profile ID for request"))
                .eraseToAnyPublisher()
        }
        return networkClient.send(request: request, type: Profile.self)
            .flatMap { profile -> NftListCombineCompletion in
                let nftIds = profile.likes
                let nftPublishers = nftIds.map { nftId in
                    self.loadNft(id: nftId)
                }
                return Publishers.MergeMany(nftPublishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Profile Methods
    
    func loadProfile(id: String) -> ProfileCombineCompletion {
        guard let request = apiRequestBuilder.getProfile(profileId: id) else {
            return Fail(error: NetworkClientError.custom("Invalid Profile ID for request"))
                .eraseToAnyPublisher()
        }
        return networkClient.send(request: request, type: Profile.self)
            .eraseToAnyPublisher()
    }
    
    func updateProfile(params: UpdateProfileParams) -> ProfileCombineCompletion {
        guard let request = apiRequestBuilder.updateProfile(params: params) else {
            return Fail(error: NetworkClientError.urlSessionError).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Profile.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Cart Methods
    
    func getCartItems() -> CartItemsCompletion {
        guard let request = apiRequestBuilder.getOrder(orderId: currentOrderId) else {
            return Fail(error: NetworkClientError.custom("Unable to form order request")).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Order.self)
            .flatMap { [weak self] order -> CartItemsCompletion in
                guard let self = self else { return Just([]).setFailureType(to: NetworkClientError.self).eraseToAnyPublisher() }
                guard !order.nfts.isEmpty else {
                    return Just([]).setFailureType(to: NetworkClientError.self).eraseToAnyPublisher()
                }
                let nftPublishers = order.nfts.map { id in
                    self.loadNft(id: id)
                }
                return Publishers.MergeMany(nftPublishers).collect().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateOrder(id: String, nftIds: [String]) -> OrderCompletion {
        guard let request = apiRequestBuilder.updateOrder(orderId: id, nftIds: nftIds) else {
            return Fail(error: NetworkClientError.custom("Unable to form update order request")).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Order.self)
            .mapError { NetworkClientError.urlRequestError($0) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Currency and Payment Methods
    
    func loadCurrencies() -> CurrencyCombineCompletion {
        guard let request = apiRequestBuilder.getCurrencies() else {
            return Fail(error: NetworkClientError.custom("Invalid URL")).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: [Currency].self)
            .eraseToAnyPublisher()
    }
    
    func payOrder(with currency: Currency) -> OrderPaymentResponseCompletion {
        guard let request = apiRequestBuilder.payOrder(orderId: currentOrderId, currencyId: currency.id) else {
            return Fail(error: NetworkClientError.custom("Invalid URL")).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: OrderPaymentResponse.self)
            .eraseToAnyPublisher()
    }
}
