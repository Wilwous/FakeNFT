//
//  FetchCatalogsRequest.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import Foundation

// MARK: - Network

struct NFTCollectionRequest: NetworkRequest {
    
    // MARK: - Public Properties
    
    let baseUrl = RequestConstants.baseURL
    var endpoint: URL? {
        URL(string: "\(baseUrl)/api/v1/collections")
    }
    var httpMethod: HttpMethod {
        .get
    }
}
