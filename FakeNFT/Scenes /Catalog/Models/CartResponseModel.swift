//
//  CartResponseModel.swift
//  FakeNFT
//
//  Created by Антон Павлов on 12.07.2024.
//

import Foundation

struct CartResponseModel: Decodable {
    let id: String
    let nfts: [String]
}
