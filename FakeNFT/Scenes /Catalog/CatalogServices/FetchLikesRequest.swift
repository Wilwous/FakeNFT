//
//  FetchLikesRequest.swift
//  FakeNFT
//
//  Created by Антон Павлов on 14.07.2024.
//

import Foundation

// MARK: - Network

struct FetchLikesRequest: NetworkRequest {
    
    // MARK: - Public Properties
    
    let baseUrl = RequestConstants.baseURL
    var httpBody: String?
    
    var endpoint: URL? {
        URL(string: "\(baseUrl)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    // MARK: - Initializers
    
    init(httpBody: String) {
        self.httpBody = httpBody
    }
}
