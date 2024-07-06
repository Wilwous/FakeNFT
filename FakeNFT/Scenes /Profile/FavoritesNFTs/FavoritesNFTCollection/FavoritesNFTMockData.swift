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
        NFTItem(imageName: "card_april", name: "Archie", ratingImageName: "rating_1", price: "1,78 ETH"),
        NFTItem(imageName: "card_april", name: "Pixi", ratingImageName: "rating_4", price: "1,78 ETH"),
        NFTItem(imageName: "card_april", name: "Melissa", ratingImageName: "rating_5", price: "1,78 ETH"),
        NFTItem(imageName: "card_april", name: "April", ratingImageName: "rating_3", price: "1,78 ETH"),
        NFTItem(imageName: "card_april", name: "Daisy", ratingImageName: "rating_1", price: "1,78 ETH"),
        NFTItem(imageName: "card_april", name: "Lilo", ratingImageName: "rating_5", price: "1,78 ETH")
    ]
}

