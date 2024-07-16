//
//  FetchCatalogsRequest.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import Foundation

// MARK: - Network

struct FetchCatalogsRequest: NetworkRequest {
    
    // MARK: - Public Properties
    
    let baseUrl = RequestConstants.baseURL
    var token: String?
    
    var endpoint: URL? {
        URL(string: "\(baseUrl)/api/v1/collections")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
}
