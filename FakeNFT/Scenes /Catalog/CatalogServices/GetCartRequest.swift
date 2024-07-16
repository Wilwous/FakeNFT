//
//  GetCartRequest.swift
//  FakeNFT
//
//  Created by Антон Павлов on 16.07.2024.
//

import Foundation

// MARK: - Network

struct GetCartRequest: NetworkRequest {
    
    // MARK: - Public Properties
    
    let baseUrl = RequestConstants.baseURL
    var httpBody: String?
    
    var endpoint: URL? {
        URL(string: "\(baseUrl)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
}
