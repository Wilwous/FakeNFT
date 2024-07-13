//
//  FavoritesNFTMockData.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 02.07.2024.
//

import UIKit

struct NFTItem {
    let imageName: String
    let name: String
    let ratingImageName: String
    let price: String
}

struct FavoritesNFTMockData {
    static let items: [NFTItem] = [
        NFTItem(
            imageName: "card_april",
            name: "Название",
            ratingImageName: "rating_0",
            price: "0 ETH"
        )
    ]
}

