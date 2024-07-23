import Foundation

// MARK: - Protocol

protocol NftStorage: AnyObject {
    func saveNft(_ nft: Nft)
    func getNft(with id: String) -> Nft?
}

final class NftStorageImpl: NftStorage {
    
    //MARK: - Static
    
    static let shared = NftStorageImpl()
    
    // MARK: - Private Properties
    
    private let syncQueue = DispatchQueue(label: "sync-nft-queue")
    private var storage: [String: Nft] = [:]
    
    //MARK: - Public Methods
    
    func saveNft(_ nft: Nft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }
    
    func getNft(with id: String) -> Nft? {
        syncQueue.sync {
            storage[id]
        }
    }
}
