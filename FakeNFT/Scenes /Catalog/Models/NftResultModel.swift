//
//  NftResultModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 12.07.2024.
//

import Foundation

struct NftDetailsResponseModel: Decodable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
