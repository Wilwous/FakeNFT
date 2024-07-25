//
//  TokenManager.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Foundation

final class TokenManager {
    
    //MARK: - Static
    
    static let shared = TokenManager()
    
    // MARK: - Public Properties
    
    var token: String?
    
    // MARK: - Initializer
    
    private init() {
        self.token = RequestConstants.tokenValue
    }
}
