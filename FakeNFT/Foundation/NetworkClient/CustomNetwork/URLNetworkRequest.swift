//
//  URLNetworkRequest.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Foundation

struct URLNetworkRequest: NetworkRequest {
    
    // MARK: - Public Properties
    
    let endpoint: URL?
    let httpMethod: HttpMethod
    let dto: Encodable?
    let isUrlEncoded: Bool
    let token: String?
    
    // MARK: - Initializer
    
    init(
        endpoint: URL?,
        httpMethod: HttpMethod,
        dto: Encodable? = nil,
        isUrlEncoded: Bool = false,
        token: String? = nil
    ) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.dto = dto
        self.isUrlEncoded = isUrlEncoded
        self.token = token ?? TokenManager.shared.token
    }
    
    //MARK: - Public Methods
    
    func update(
        endpoint: URL?
    ) -> Self {
        .init(
            endpoint: endpoint,
            httpMethod: httpMethod,
            dto: dto,
            isUrlEncoded: isUrlEncoded,
            token: token
        )
    }
    
    func update(
        httpMethod: HttpMethod
    ) -> Self {
        .init(
            endpoint: endpoint,
            httpMethod: httpMethod,
            dto: dto,
            isUrlEncoded: isUrlEncoded,
            token: token
        )
    }
    
    func update(
        dto: Encodable?
    ) -> Self {
        .init(
            endpoint: endpoint,
            httpMethod: httpMethod,
            dto: dto,
            isUrlEncoded: isUrlEncoded,
            token: token
        )
    }
    
    func update(
        isUrlEncoded: Bool
    ) -> Self {
        .init(
            endpoint: endpoint,
            httpMethod: httpMethod,
            dto: dto,
            isUrlEncoded: isUrlEncoded,
            token: token
        )
    }
    func update(
        token: String?
    ) -> Self {
        .init(
            endpoint: endpoint,
            httpMethod: httpMethod,
            dto: dto,
            isUrlEncoded: isUrlEncoded,
            token: token
        )
    }
}
