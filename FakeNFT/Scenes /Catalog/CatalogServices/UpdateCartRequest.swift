//
//  File.swift
//  FakeNFT
//
//  Created by Антон Павлов on 16.07.2024.
//

import Foundation

// MARK: - Network

struct UpdateCartRequest: NetworkRequest {
    
    // MARK: - Public Properties
    
    let baseUrl = RequestConstants.baseURL
    var token: String?
    
    var endpoint: URL? {
        URL(string: "\(baseUrl)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod {
        .put
    }
    
    // MARK: - Initializers
    
    init(token: String) {
        self.token = token
    }
}
