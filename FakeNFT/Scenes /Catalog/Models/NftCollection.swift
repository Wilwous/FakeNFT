//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Антон Павлов on 02.07.2024.
//

import Foundation

// MARK: - Model

struct NftCollection: Decodable {
    let id: String
    let nfts: [String]
    let name: String
    let cover: String
}
