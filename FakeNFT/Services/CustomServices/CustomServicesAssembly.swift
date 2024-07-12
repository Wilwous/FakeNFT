//
//  CustomServicesAssembly.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 28/06/2024.
//

import Foundation

final class CustomServicesAssembly {
    private let servicesAssembly: ServicesAssembly
    private let apiRequestBuilder: ApiRequestBuilderProtocol
    
    init(
        servicesAssembly: ServicesAssembly,
        apiRequestBuilder: ApiRequestBuilderProtocol = ApiRequestBuilder()
    ) {
        self.servicesAssembly = servicesAssembly
        self.apiRequestBuilder = apiRequestBuilder
    }
    
    func nftServiceCombine() throws -> NftServiceCombine {
        return NftServiceCombineImp(
            networkClient: try combineNetworkClient(),
            storage: servicesAssembly.nftStorage,
            apiRequestBuilder: apiRequestBuilder
        )
    }
    
    func createProfileViewController() throws -> ProfileViewController {
        let nftServiceCombine = try self.nftServiceCombine()
        return ProfileViewController()
    }
    
    func createCartViewController() throws -> CartViewController {
        let nftServiceCombine = try self.nftServiceCombine()
        return CartViewController()
    }
    
    private func combineNetworkClient() throws -> NetworkClientCombine {
        guard let defaultNetworkClient = servicesAssembly.networkClient as? DefaultNetworkClient else {
            throw NetworkClientError.custom("Network client is not of type DefaultNetworkClient")
        }
        return NetworkClientCombine(baseClient: defaultNetworkClient)
    }
}

